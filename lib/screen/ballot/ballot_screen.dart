import 'package:flutter/material.dart';

import '../../widget/menu_widget.dart';

class BallotScreen extends StatefulWidget {
  const BallotScreen({super.key});

  @override
  State<BallotScreen> createState() => _BallotScreenState();
}

class _BallotScreenState extends State<BallotScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Stack(children: <Widget>[
        Positioned(
            top: 0,
            height: height * 0.17,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(45)),
              child: Container(
                  padding: const EdgeInsets.only(
                      top: 21, left: 32, right: 32, bottom: 10),
                  color: theme.scaffoldBackgroundColor,
                  child: Center(
                    child: Text(
                      "Ballot",
                      style: theme.textTheme.headlineLarge,
                    ),
                  )),
            )),
        Positioned(
            top: height * 0.04,
            height: height * 0.05,
            left: 0,
            right: height / 2.5,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(color: Colors.black, blurRadius: 1)
                  ]),
              child: const MenuWidget(),
            )),
        Positioned(
            top: height * 0.19,
            height: height * 0.7,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(45), bottom: Radius.circular(45)),
              child: Container(
                color: theme.scaffoldBackgroundColor,
              ),
            )),
      ]),
    );
  }
}
