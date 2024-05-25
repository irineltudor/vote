import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class StorageService {
  final firebase_storage.FirebaseStorage storageService =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(
    String path,
    File file,
  ) async {
    try {
      await storageService.ref().child(path).putFile(file);
    } on firebase_storage.FirebaseException catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<String> getProfilePicture(String uid) async {
    String imageUrl = 'profile-pic/$uid.png';
    String ref = 'profile-pic/';
    String error = "";
    String downloadURL = "";
    try {
      final list = await storageService.ref().child(ref).listAll();

      if (list.items.indexWhere((element) => element.fullPath == imageUrl) !=
          -1) {
        downloadURL = await storageService.ref(imageUrl).getDownloadURL();
      } else {
        downloadURL = await storageService
            .ref("profile-pic/profile.jpg")
            .getDownloadURL();
      }
    } catch (myError) {
      error = myError.toString();
    }

    return downloadURL;
  }

  Future<String> getCandidatePicture(String name) async {
    String imageUrl = 'candidate-pic/$name.png';
    String ref = 'candidate-pic';
    String error = "";
    String downloadURL = "";

    try {
      final list = await storageService.ref().child(ref).listAll();

      if (list.items.indexWhere((element) => element.fullPath == imageUrl) !=
          -1) {
        downloadURL = await storageService.ref(imageUrl).getDownloadURL();
      } else {
        downloadURL = await storageService
            .ref("candidate/candidate.png")
            .getDownloadURL();
      }
    } catch (myError) {
      error = myError.toString();
    }
    return downloadURL;
  }

  Future<String> getElectionPicture(String name) async {
    String imageUrl = 'election/$name.jpg';
    String error = "";
    String ref = 'election/';
    String downloadURL = "";
    try {
      final list = await storageService.ref().child(ref).listAll();

      if (list.items.indexWhere((element) => element.fullPath == imageUrl) !=
          -1) {
        downloadURL = await storageService.ref(imageUrl).getDownloadURL();
      } else {
        downloadURL =
            await storageService.ref("election/election.jpg").getDownloadURL();
      }
    } catch (myError) {
      error = myError.toString();
    }

    return downloadURL;
  }
}
