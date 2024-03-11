import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lottie/lottie.dart';

class Intro1Screen extends StatelessWidget {
  const Intro1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset("assets/animations/blockchain_animation.json"),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Vote with blockchain: ",
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
            Text(
              "Easy, secure, and everywhere!",
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ]),
    );
  }
}
