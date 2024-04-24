import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 2);
            });
          },
          children: const [
            VerifyIntroScreen(),
            CardDetailsScreen(),
            FacialRecognitionScreen(),
          ],
        ),
        Container(
            alignment: const Alignment(0, 0.95),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      onLastPage ? null : _controller.jumpToPage(3);
                    },
                    child: onLastPage
                        ? Text(
                            "skip",
                            style: TextStyle(
                                color: theme.scaffoldBackgroundColor,
                                fontWeight: FontWeight.bold),
                          )
                        : Text(
                            "skip",
                            style: TextStyle(
                                color: theme.primaryColor,
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
                          Navigator.of(context).pop("refresh");
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
