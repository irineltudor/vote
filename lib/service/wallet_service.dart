import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vote/model/Wallet.dart';

class WalletService {
  String collection = "wallet";
  User? user = FirebaseAuth.instance.currentUser;

  Future<List<Wallet>> getAll() async {
    List<Wallet> walletList = [];
    await FirebaseFirestore.instance.collection(collection).get().then((value) {
      Wallet wallet;
      for (var element in value.docs) {
        wallet = Wallet.fromMap(element.data());
        walletList.add(wallet);
      }
    });

    return walletList;
  }

  Future<Wallet> getWallet(String cnp) async {
    Wallet wallet = Wallet();
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(cnp)
        .get()
        .then((value) {
      wallet = Wallet.fromMap(value.data());
    });
    return wallet;
  }
}
