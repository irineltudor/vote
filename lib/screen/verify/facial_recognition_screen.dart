import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:vote/model/user.dart';
import 'package:vote/service/storage_service.dart';
import 'package:vote/service/user_service.dart';

class FacialRecognitionScreen extends StatefulWidget {
  const FacialRecognitionScreen({super.key});

  @override
  State<FacialRecognitionScreen> createState() =>
      _FacialRecognitionScreenState();
}

class _FacialRecognitionScreenState extends State<FacialRecognitionScreen> {
  UserModel loggedInUser = UserModel();
  User? user = FirebaseAuth.instance.currentUser;
  final UserService userService = UserService();
  final StorageService storageService = StorageService();
  File? _selfie;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    userService.getUser(user!.uid).then((value) {
      loggedInUser = value;
      setState(() {});
    });
  }

  void _startUpload() {
    String path = 'profile-pic/${loggedInUser.uid!}.png';
    storageService.uploadFile(path, _selfie!);
  }

  Future<void> _pickImage(ImageSource source) async {
    XFile? selected = await ImagePicker().pickImage(source: source);

    setState(() {
      if (selected != null) _selfie = File(selected.path);
    });
  }

  void _clear() {
    setState(() => _selfie = null);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (loggedInUser.firstname == null) {
      return Container(
          color: theme.primaryColor,
          child: Center(
              child: CircularProgressIndicator(
            color: theme.scaffoldBackgroundColor,
          )));
    } else {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(height / 10)),
                child: Container(
                    height: height / 1.75,
                    color: theme.primaryColor,
                    child: Stack(
                        alignment: AlignmentDirectional.bottomStart,
                        children: [
                          Center(
                            child: _selfie == null
                                ? LottieBuilder.asset(
                                    'assets/animations/selfie_animation.json',
                                    width: width,
                                  )
                                : Image.file(
                                    _selfie!,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(50),
                            width: double.maxFinite,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                  Colors.black45,
                                  Colors.transparent,
                                ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: Text(
                                    _selfie == null
                                        ? "Take a picture in good light"
                                        : "Looking good !",
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Center(
                                    child: _selfie == null
                                        ? GestureDetector(
                                            onTap: () {
                                              _pickImage(ImageSource.camera);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(45)),
                                                  border: Border.all(
                                                      color: Colors.white)),
                                              child: const Icon(
                                                Icons.camera,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  postDetailsToDB();
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  45)),
                                                      border: Border.all(
                                                          color: Colors.white)),
                                                  child: const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 100,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  _clear();
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  45)),
                                                      border: Border.all(
                                                          color: Colors.white)),
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ))
                              ],
                            ),
                          ),
                        ])),
              ),
              const SizedBox(
                height: 100,
              ),
            ]),
          ),
        ),
      );
    }
  }

  postDetailsToDB() async {
    ThemeData theme = Theme.of(context);
    if (_selfie == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Get A Picture"),
        ));
      }
    } else {
      _startUpload();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.fromLTRB(100, 0, 100, 400),
            duration: const Duration(seconds: 1),
            content: const Text(
              "Details Updated",
            ),
            backgroundColor: theme.primaryColor,
          ),
        );
      }
    }
  }
}
