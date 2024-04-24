import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vote/screen/onboarding/intro4_screen.dart';
import 'package:vote/screen/onboarding/intro1_screen.dart';
import 'package:vote/screen/onboarding/intro2_screen.dart';
import 'package:vote/screen/onboarding/intro3_screen.dart';
import 'package:vote/screen/signup-signin/login_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
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
              onLastPage = (index == 3);
            });
          },
          children: const [
            Intro1Screen(),
            Intro2Screen(),
            Intro3Screen(),
            Intro4Screen()
          ],
        ),
        Container(
            alignment: const Alignment(0, 0.75),
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
                            style: TextStyle(color: theme.primaryColor),
                          )
                        : Text(
                            "skip",
                            style:
                                TextStyle(color: theme.scaffoldBackgroundColor),
                          )),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 4,
                  effect: ExpandingDotsEffect(
                    dotColor: theme.scaffoldBackgroundColor,
                    activeDotColor: const Color.fromARGB(255, 12, 100, 250),
                  ),
                ),
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const LoginScreen();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "done",
                          style:
                              TextStyle(color: theme.scaffoldBackgroundColor),
                        ))
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: Text(
                          "next",
                          style:
                              TextStyle(color: theme.scaffoldBackgroundColor),
                        )),
              ],
            ))
      ]),
    );
  }
}
