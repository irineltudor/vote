import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:vote/service/storage_service.dart';
import 'package:image/image.dart' as img;

class FaceRecognitionService {
  final apiKey = '9958eebdaa2c43f1b311e4082ac5d716';
  final apiEndpoint =
      'https://votefaceapi.cognitiveservices.azure.com/face/v1.0/';
  final String personGroupId = "vote_group";

  final StorageService storageService = StorageService();

  void _startUpload(Uint8List idCardImage, Uint8List selfieImage, String uid) {
    String path1 = 'verification/idcard/$uid.png';
    storageService.uploadImage(path1, idCardImage);
    String path2 = 'verification/selfie/$uid.png';
    storageService.uploadImage(path2, selfieImage);
  }

  Future<void> postFaces(File idCardImage, File selfieImage, String uid) async {
    final faceRectangleIdCard = await detectFace(idCardImage);
    final faceRectangleSelfie = await detectFace(selfieImage);

    final croppedCardImage =
        _cropFace(idCardImage.readAsBytesSync(), faceRectangleIdCard);

    final croppedSelfieImage =
        _cropFace(selfieImage.readAsBytesSync(), faceRectangleSelfie);

    _startUpload(croppedCardImage, croppedSelfieImage, uid);
  }

  // Future<bool> verifyFaces(File idCardImage, File selfieImage) async {
  //   // Create a new person and add the ID card face to it
  //   final personId = await createPerson();
  //   if (personId == null) return false;

  //   await addFaceToPerson(personId, idCardImage);

  //   // Train the person group after adding the face
  //   await trainPersonGroup();

  //   // Detect face in the selfie
  //   final selfieFaceId = await detectFace(selfieImage!);
  //   if (selfieFaceId == null) return false;

  //   // Verify the detected face against the person group
  //   final isIdentical = await verifyFaceWithPersonGroup(selfieFaceId, personId);

  //   return isIdentical;
  // }

  Future<Map<String, dynamic>> detectFace(File image) async {
    final endpoint = apiEndpoint + '/detect';
    final bytes = await image.readAsBytes();
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/octet-stream',
        'Ocp-Apim-Subscription-Key': apiKey,
      },
      body: bytes,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        print("DATA IS NOT EMPTY");
        return data[0]['faceRectangle'];
      }
    }

    return {};
  }

  Uint8List _cropFace(
      Uint8List imageBytes, Map<String, dynamic> faceRectangle) {
    print(faceRectangle);
    final image = img.decodeImage(imageBytes);
    final top = faceRectangle['top'];
    final left = faceRectangle['left'];
    final width = faceRectangle['width'];
    final height = faceRectangle['height'];

    final croppedImage = img.copyCrop(image!, left, top, width, height);
    final croppedBytes = Uint8List.fromList(img.encodePng(croppedImage));

    return croppedBytes;
  }

  Future<void> createPersonGroup() async {
    final response = await http.put(
      Uri.parse('$apiEndpoint/largepersongroups/$personGroupId'),
      headers: {
        'Content-Type': 'application/json',
        'Ocp-Apim-Subscription-Key': apiKey,
      },
      body: json.encode({
        'name': personGroupId,
        'userData': 'Person group for face verification',
      }),
    );

    print(response.body);

    if (response.statusCode == 200) {
      print('Person group created successfully');
    } else {
      print('Error creating person group: ${response.body}');
    }
  }

  Future<String?> createPerson() async {
    final response = await http.post(
      Uri.parse('$apiEndpoint/persongroups/$personGroupId/persons'),
      headers: {
        'Content-Type': 'application/json',
        'Ocp-Apim-Subscription-Key': apiKey,
      },
      body: json.encode({
        'name': 'Test Person',
        'userData': 'Test user data',
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['personId'];
    } else {
      print('Error creating person: ${response.body}');
      return null;
    }
  }

  Future<void> addFaceToPerson(String personId, File image) async {
    final bytes = await image.readAsBytes();
    final response = await http.post(
      Uri.parse(
          '$apiEndpoint/persongroups/$personGroupId/persons/$personId/persistedFaces'),
      headers: {
        'Content-Type': 'application/octet-stream',
        'Ocp-Apim-Subscription-Key': apiKey,
      },
      body: bytes,
    );

    if (response.statusCode == 200) {
      print('Face added to person successfully');
    } else {
      print('Error adding face to person: ${response.body}');
    }
  }

  Future<void> trainPersonGroup() async {
    final response = await http.post(
      Uri.parse('$apiEndpoint/persongroups/$personGroupId/train'),
      headers: {
        'Ocp-Apim-Subscription-Key': apiKey,
      },
    );

    if (response.statusCode == 202) {
      print('Person group training initiated');
    } else {
      print('Error training person group: ${response.body}');
    }
  }

  Future<bool> verifyFaceWithPersonGroup(String faceId, String personId) async {
    final response = await http.post(
      Uri.parse('$apiEndpoint/verify'),
      headers: {
        'Content-Type': 'application/json',
        'Ocp-Apim-Subscription-Key': apiKey,
      },
      body: json.encode({
        'faceId': faceId,
        'personId': personId,
        'personGroupId': personGroupId,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['isIdentical'];
    } else {
      print('Error verifying face: ${response.body}');
    }

    return false;
  }
}
