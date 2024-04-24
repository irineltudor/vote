import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Intro3Screen extends StatelessWidget {
  const Intro3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

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
              "Verify it using your identification card",
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: theme.scaffoldBackgroundColor),
            ),
          ]),
    );
  }
}
