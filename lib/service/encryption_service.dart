import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:vote/model/wallet.dart';

class EncryptionService {
  String keyPath = "assets/secret.json";

  Future<String> getUserWalletId(String personalCode) async {
    String jsonString = await rootBundle.loadString(keyPath);
    final secret = json.decode(jsonString);

    return secret["wallet_keys"][personalCode]['document_id'];
  }

  Future<Map<String, String>> encryptIdCard(Map<String, String> idCard) async {
    // Load keys from JSON file
    String jsonString = await rootBundle.loadString(keyPath);
    final secret = json.decode(jsonString);
    final fernetKey = secret['fernet_key'];

    final key = Key.fromBase64(fernetKey);
    final encrypter = Encrypter(Fernet(key));

    idCard.updateAll(
      (key, value) {
        final encValue = encrypter.encrypt(value).base64;
        return encValue;
      },
    );

    return idCard;
  }

  Future<Map<String, String>> decryptIdCard(Map<String, String> idCard) async {
    // Load keys from JSON file
    String jsonString = await rootBundle.loadString(keyPath);
    final secret = json.decode(jsonString);
    final fernetKey = secret['fernet_key'];

    final key = Key.fromBase64(fernetKey);
    final encrypter = Encrypter(Fernet(key));

    idCard.updateAll((key, value) {
      final decValue = encrypter.decrypt64(value);

      return decValue;
    });

    return idCard;
  }

  Future<UserWallet> decryptWallet(
      UserWallet wallet, String personalCode) async {
    String jsonString = await rootBundle.loadString(keyPath);
    final secret = json.decode(jsonString);
    final privateKeyPem = secret['wallet_keys'][personalCode]['private_key'];

    // Parse private key
    final privateKey = RSAKeyParser().parse(privateKeyPem) as RSAPrivateKey;

    final encrypter = Encrypter(RSA(
      privateKey: privateKey,
      encoding: RSAEncoding.OAEP,
      digest: RSADigest.SHA256,
    ));

    final decAddress =
        encrypter.decrypt(Encrypted(base64.decode(wallet.address!)));

    final decOwner = encrypter.decrypt(Encrypted(base64.decode(wallet.owner!)));

    final decPrivateKey =
        encrypter.decrypt(Encrypted(base64.decode(wallet.privateKey!)));

    wallet.address = decAddress;
    wallet.owner = decOwner;
    wallet.privateKey = decPrivateKey;

    return wallet;
  }
}
