import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class StorageService {
  final firebase_storage.FirebaseStorage storageService =
      firebase_storage.FirebaseStorage.instance;

  Future<String> getProfilePicture(String uid) async {
    String imageUrl = 'profile-pic/$uid.png';
    String error = "";
    String downloadURL = "";
    try {
      await storageService.ref(imageUrl).getDownloadURL();
    } on firebase_storage.FirebaseException catch (myError) {
      switch (myError.code) {
        case 'object-not-found':
          error = myError.toString();
      }
    }

    if (error == "") {
      downloadURL = await storageService.ref(imageUrl).getDownloadURL();
    } else {
      downloadURL =
          await storageService.ref("profile-pic/profile.jpg").getDownloadURL();
    }

    return downloadURL;
  }

  Future<String> getCandidatePicture(String name) async {
    String imageUrl = 'candidate-pic/$name.png';
    String error = "";
    String downloadURL = "";
    try {
      await storageService.ref(imageUrl).getDownloadURL();
    } on firebase_storage.FirebaseException catch (myError) {
      switch (myError.code) {
        case 'object-not-found':
          error = myError.toString();
      }
    }

    if (error == "") {
      downloadURL = await storageService.ref(imageUrl).getDownloadURL();
    } else {
      downloadURL =
          await storageService.ref("candidate/candidate.png").getDownloadURL();
    }

    return downloadURL;
  }

  Future<String> getElectionPicture(String name) async {
    String imageUrl = 'election/$name.jpg';
    String error = "";
    String downloadURL = "";
    try {
      await storageService.ref(imageUrl).getDownloadURL();
    } on firebase_storage.FirebaseException catch (myError) {
      switch (myError.code) {
        case 'object-not-found':
          error = myError.toString();
      }
    }

    if (error == "") {
      downloadURL = await storageService.ref(imageUrl).getDownloadURL();
    } else {
      downloadURL =
          await storageService.ref("election/election.jpg").getDownloadURL();
    }

    return downloadURL;
  }
}
