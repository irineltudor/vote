import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:vote/model/user.dart';
import 'package:vote/service/storage_service.dart';
import 'package:vote/service/user_service.dart';

class FacialRecognitionScreen extends StatefulWidget {
  final Function function;
  final bool cardIdUpdated;
  const FacialRecognitionScreen(
      {super.key, required this.function, required this.cardIdUpdated});

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
  bool facialUpdated = false;
  bool waitingForUpload = false;

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
                                        : facialUpdated
                                            ? "Selfie updated"
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
                                              if (widget.cardIdUpdated) {
                                                _pickImage(ImageSource.camera);
                                              } else {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "Try updating your card details first",
                                                  backgroundColor: Colors.red,
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity:
                                                      ToastGravity.SNACKBAR,
                                                );
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(45)),
                                                  border: Border.all(
                                                      width: 3,
                                                      color: Colors.white)),
                                              child: Icon(
                                                Icons.camera,
                                                color: theme.primaryColor,
                                              ),
                                            ),
                                          )
                                        : AnimatedContainer(
                                            duration:
                                                const Duration(seconds: 2),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    facialUpdated
                                                        ? null
                                                        : postDetailsToDB();
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                        color: facialUpdated
                                                            ? Colors.white
                                                            : Colors.green,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    45)),
                                                        border: Border.all(
                                                            width: 3,
                                                            color:
                                                                Colors.white)),
                                                    child: Icon(
                                                      Icons.check,
                                                      color: facialUpdated
                                                          ? Colors.green
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                facialUpdated
                                                    ? Container()
                                                    : const SizedBox(
                                                        width: 100,
                                                      ),
                                                facialUpdated
                                                    ? Container()
                                                    : GestureDetector(
                                                        onTap: () {
                                                          _clear();
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .redAccent,
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          45)),
                                                              border: Border.all(
                                                                  width: 3,
                                                                  color: Colors
                                                                      .white)),
                                                          child: const Icon(
                                                            Icons.close,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      )
                                              ],
                                            ),
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
    if (_selfie == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Get A Picture"),
        ));
      }
    } else {
      _startUpload();
      userService.setStatusToWaiting(loggedInUser);
      setState(() {
        facialUpdated = true;
      });
      widget.function.call(true, _selfie!);
    }
  }
}
