import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vote/model/user.dart';
import 'package:vote/model/wallet.dart';
import 'package:vote/service/encryption_service.dart';

class WalletService {
  String collection = "wallet";
  User? user = FirebaseAuth.instance.currentUser;
  final EncryptionService encryptionService = EncryptionService();

  Future<List<UserWallet>> getAll() async {
    List<UserWallet> walletList = [];
    await FirebaseFirestore.instance.collection(collection).get().then((value) {
      UserWallet wallet;
      for (var element in value.docs) {
        wallet = UserWallet.fromMap(element.data());
        walletList.add(wallet);
      }
    });

    return walletList;
  }

  Future<UserWallet> getWallet(UserModel user) async {
    UserWallet wallet = UserWallet();
    if (user.status == 1) {
      String personalCode = user.idCard!['personalCode']!;
      String id = await encryptionService.getUserWalletId(personalCode);
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(id)
          .get()
          .then((value) async {
        final encWallet = UserWallet.fromMap(value.data());
        wallet = await encryptionService.decryptWallet(encWallet, personalCode);
      });
    }

    return wallet;
  }
}
