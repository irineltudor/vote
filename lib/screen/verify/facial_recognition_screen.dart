import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                  child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(45)),
                                      border: Border.all(color: Colors.white)),
                                  child: const Icon(
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
            const SizedBox(
              height: 100,
            ),
          ]),
        ),
      ),
    );
  }
}
