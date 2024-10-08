import 'package:flutter/material.dart';

class VerifyIntroScreen extends StatefulWidget {
  const VerifyIntroScreen({super.key});

  @override
  State<VerifyIntroScreen> createState() => _VerifyIntroScreenState();
}

class _VerifyIntroScreenState extends State<VerifyIntroScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: theme.scaffoldBackgroundColor,
        padding: EdgeInsets.fromLTRB(50, height / 7, 50, 0),
        child: Stack(children: [
          Column(
            children: [
              Image.asset(
                'assets/verify/person-and-idcard.png',
                height: height / 2,
              ),
              Column(
                children: [
                  Text(
                    'Verify your account',
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(color: theme.primaryColor),
                  ),
                  SizedBox(
                    height: height / 20,
                  ),
                  Text(
                    'Take your ID, scan it, and then, using facial recognition, verify the account.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
