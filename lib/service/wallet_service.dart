import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vote/model/wallet.dart';

class WalletService {
  String collection = "wallet";
  User? user = FirebaseAuth.instance.currentUser;

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

  Future<UserWallet> getWallet(String cnp) async {
    UserWallet wallet = UserWallet();
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(cnp)
        .get()
        .then((value) {
      wallet = UserWallet.fromMap(value.data());
    });
    return wallet;
  }
}
