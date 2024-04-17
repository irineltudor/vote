import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user.dart';

class UserService {
  String collection = "user";

  Future<UserModel> getUser(String uid) async {
    UserModel user = UserModel();
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(uid)
        .get()
        .then((value) {
      user = UserModel.fromMap(value.data());
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
    user.pin = pin;
    await FirebaseFirestore.instance
        .collection("user")
        .doc(user.uid!)
        .set(user.toMap());
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

    user.idCard = idCard;
    user.status = 0;

    await FirebaseFirestore.instance
        .collection("user")
        .doc(user.uid)
        .set(user.toMap());
  }

  Future<void> updateIdCard(
      UserModel user, LinkedHashMap<String, String> idCard) async {
    user.idCard = idCard;
    user.status = 2;

    await FirebaseFirestore.instance
        .collection("user")
        .doc(user.uid)
        .set(user.toMap());
  }
}
