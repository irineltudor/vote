import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vote/screen/verify/card_details_screen.dart';
import 'package:vote/screen/verify/facial_recognition_screen.dart';
import 'package:vote/screen/verify/verify_intro_screen.dart';

class CardChangeScreen extends StatefulWidget {
  const CardChangeScreen({super.key});

  @override
  State<CardChangeScreen> createState() => _CardChangeScreenState();
}

class _CardChangeScreenState extends State<CardChangeScreen> {
  final PageController _controller = PageController();

  bool onLastPage = false;
  bool onFirstPage = true;
  bool cardIdUpdate = false;
  bool facialUpdate = false;

  void setCardIdUpdate(bool condition) {
    setState(() {
      cardIdUpdate = condition;
    });
  }

  void setFacialUpdate(bool condition) {
    setState(() {
      facialUpdate = condition;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

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
            FacialRecognitionScreen(function: setFacialUpdate),
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
                        onTap: () {
                          if (!cardIdUpdate || facialUpdate) {
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
