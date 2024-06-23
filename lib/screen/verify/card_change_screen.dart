import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vote/screen/verify/card_details_screen.dart';
import 'package:vote/screen/verify/facial_recognition_screen.dart';
import 'package:vote/screen/verify/verify_intro_screen.dart';
import 'package:vote/service/face_recognition_service.dart';
import 'package:vote/service/user_service.dart';

class CardChangeScreen extends StatefulWidget {
  const CardChangeScreen({super.key});

  @override
  State<CardChangeScreen> createState() => _CardChangeScreenState();
}

class _CardChangeScreenState extends State<CardChangeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final PageController _controller = PageController();
  final FaceRecognitionService faceRecognitionService =
      FaceRecognitionService();

  final UserService userService = UserService();

  late File _idCardImage;
  late File _selfieImage;

  bool onLastPage = false;
  bool onFirstPage = true;
  bool cardIdUpdated = false;
  bool facialUpdate = false;
  bool waitingForProcess = false;

  void setCardIdUpdate(bool condition, File image) {
    setState(() {
      cardIdUpdated = condition;
      _idCardImage = image;
    });
  }

  void setFacialUpdate(bool condition, File image) {
    setState(() {
      facialUpdate = condition;
      _selfieImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    if (waitingForProcess) {
      return Container(
        color: theme.primaryColor,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.asset(
                  "assets/animations/verify_account_animation.json"),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Waiting for your verification",
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: theme.scaffoldBackgroundColor),
              ),
              const SizedBox(
                height: 10,
              ),
              CircularProgressIndicator(
                color: theme.scaffoldBackgroundColor,
              )
            ]),
      );
    } else {
      return Scaffold(
        body: Stack(children: [
          PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            reverse: false,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
                onFirstPage = (index == 0);
              });
            },
            children: [
              const VerifyIntroScreen(),
              CardDetailsScreen(function: setCardIdUpdate),
              FacialRecognitionScreen(
                  function: setFacialUpdate, cardIdUpdated: cardIdUpdated),
            ],
          ),
          Container(
              alignment: const Alignment(0, 0.95),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () {
                        onLastPage
                            ? _controller.jumpToPage(1)
                            : Navigator.of(context).pop("refresh");
                      },
                      child: (onFirstPage)
                          ? Text(
                              "skip",
                              style: TextStyle(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold),
                            )
                          : (onLastPage)
                              ? Text(
                                  "back",
                                  style: TextStyle(
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  "    ",
                                  style: TextStyle(
                                      color: theme.scaffoldBackgroundColor,
                                      fontWeight: FontWeight.bold),
                                )),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      dotColor: theme.primaryColor,
                      activeDotColor: const Color.fromARGB(255, 12, 100, 250),
                    ),
                  ),
                  onLastPage
                      ? GestureDetector(
                          onTap: () async {
                            if (!cardIdUpdated || facialUpdate) {
                              setState(() {
                                waitingForProcess = true;
                              });
                              await faceRecognitionService.postFaces(
                                  _idCardImage, _selfieImage, user!.uid);

                              bool identical = await faceRecognitionService
                                  .verifyFaces(_idCardImage, _selfieImage);

                              if (identical == true) {
                                userService.setStatusToVerified();
                              }

                              Fluttertoast.showToast(
                                msg: "Done! Wait for confirmation.",
                                backgroundColor: theme.primaryColor,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.SNACKBAR,
                              );

                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop("refresh");
                            } else {
                              Fluttertoast.showToast(
                                msg: "You've updated the card but no the photo",
                                backgroundColor: Colors.red,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.SNACKBAR,
                              );
                            }
                          },
                          child: Text(
                            "done",
                            style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold),
                          ))
                      : GestureDetector(
                          onTap: () {
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child: Text(
                            "next",
                            style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold),
                          )),
                ],
              ))
        ]),
      );
    }
  }
}
