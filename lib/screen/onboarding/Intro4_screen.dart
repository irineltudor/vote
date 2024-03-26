import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lottie/lottie.dart';

class Intro4Screen extends StatelessWidget {
  const Intro4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset("assets/animations/vote_animation.json"),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Now you can vote from anywhere",
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: theme.scaffoldBackgroundColor),
            ),
          ]),
    );
  }
}
