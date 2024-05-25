import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vote/service/encryption_service.dart';

import '../model/user.dart';

class UserService {
  String collection = "user";
  User? user = FirebaseAuth.instance.currentUser;
  final EncryptionService encryptionService = EncryptionService();

  Future<UserModel> getUser(String uid) async {
    UserModel user = UserModel();
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(uid)
        .get()
        .then((value) async {
      user = UserModel.fromMap(value.data());

      if (user.idCard!['address'] != "") {
        user.idCard = await encryptionService.decryptIdCard(user.idCard!);
      }
    });

    return user;
  }

  Future<void> addUser(UserModel user) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(user.uid)
        .set(user.toMap());
  }

  Future<void> updatePin(UserModel user, String pin) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(user.uid!)
        .update({'pin': pin});
  }

  Future<void> updatePhoneNumber(UserModel user, String phoneNumber) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(user.uid!)
        .update({'phoneNumber': phoneNumber});
  }

  Future<void> deleteIdCard(UserModel user) async {
    LinkedHashMap<String, String> idCard = LinkedHashMap();

    idCard['firstname'] = "";
    idCard['lastname'] = "";
    idCard['sex'] = "";
    idCard['nationality'] = "";
    idCard['country'] = "";
    idCard['county'] = "";
    idCard['city'] = "";
    idCard['address'] = "";
    idCard['dob'] = "";
    idCard['personalCode'] = "";
    idCard['issueDate'] = "";
    idCard['expireDate'] = "";

    await FirebaseFirestore.instance
        .collection("user")
        .doc(user.uid)
        .update({'idCard': idCard, 'status': 0});
  }

  Future<void> updateIdCard(
      UserModel user, LinkedHashMap<String, String> idCard) async {
    user.idCard = await encryptionService.encryptIdCard(idCard);
    user.status = 2;

    await FirebaseFirestore.instance
        .collection("user")
        .doc(user.uid)
        .update({'idCard': user.idCard, 'status': user.status});
  }

  Future<String> changePassword(String newPassword, String oldPassword) async {
    var credentials = EmailAuthProvider.credential(
        email: user?.email ?? " ", password: oldPassword);

    try {
      await user
          ?.reauthenticateWithCredential(credentials)
          .then((value) async => {
                user
                    ?.updatePassword(newPassword)
                    // ignore: body_might_complete_normally_catch_error
                    .catchError((onError) {
                  // ignore: invalid_return_type_for_catch_error
                  return "Password can't be changed $onError";
                })
              });
      return "Successfully changed password";
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          return "Your email address appears to be malformed.";
        case "wrong-password":
          return "Current password is wrong.";
        case "user-not-found":
          return "User with this email doesn't exist.";
        case "user-disabled":
          return "User with this email has been disabled.";
        case "too-many-requests":
          return "Too many requests";
        case "operation-not-allowed":
          return "Signing in with Email and Password is not enabled.";
        default:
          return "An undefined Error happened.";
      }
    }
  }
}
