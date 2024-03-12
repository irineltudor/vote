import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lottie/lottie.dart';
import 'package:vote/screen/home/home_screen.dart';
import 'package:vote/screen/navigator/navigator_screen.dart';

class FacialRecognitionScreen extends StatefulWidget {
  const FacialRecognitionScreen({super.key});

  @override
  State<FacialRecognitionScreen> createState() =>
      _FacialRecognitionScreenState();
}

class _FacialRecognitionScreenState extends State<FacialRecognitionScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(height / 10)),
              child: Container(
                  height: height / 1.3,
                  color: theme.primaryColor,
                  child: Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        Center(
                          child: LottieBuilder.asset(
                            'assets/animations/selfie_animation.json',
                            width: width,
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
                                  "Take a picture in good light",
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                  child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(45)),
                                      border: Border.all(color: Colors.white)),
                                  child: Icon(
                                    Icons.camera,
                                    color: Colors.white,
                                  ),
                                ),
                              ))
                            ],
                          ),
                        ),
                      ])),
            ),
            SizedBox(
              height: 100,
            ),
            _next(theme: theme)
          ]),
        ),
      ),
    );
  }

  Widget _next({required ThemeData theme}) {
    return Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const NavigatorScreen()));
        },
        child: Text(
          "Next",
          style: theme.textTheme.bodyLarge?.copyWith(color: theme.primaryColor),
        ),
      ),
    );
  }
}
