import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:vote/screen/more/pin_screen.dart';

import 'pin_dialog_widget.dart';

class CustomCardWidget extends StatelessWidget {
  String text;
  IconData icon;
  ThemeData theme;
  StatefulWidget statefulWidget;
  String pin;

  CustomCardWidget(
      {super.key,
      required this.text,
      required this.icon,
      required this.theme,
      required this.statefulWidget,
      required this.pin});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        pin != '----'
            ? showDialog(
                context: context,
                barrierColor: Colors.black38,
                builder: (BuildContext context) {
                  return PinDialogBox(
                    function: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => statefulWidget));
                    },
                    pin: pin,
                  );
                })
            : Navigator.push(context,
                MaterialPageRoute(builder: (context) => statefulWidget));
      },
      child: Container(
        height: 160,
        width: 150,
        decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(50)),
            border: Border.all(
                color: theme.dialogBackgroundColor.withOpacity(0.5), width: 2),
            boxShadow: ([
              BoxShadow(
                  color: theme.dialogBackgroundColor.withOpacity(0.8),
                  blurRadius: 1.5)
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: theme.primaryColor,
              size: 75,
            ),
            Text(
              text,
              style: theme.textTheme.bodySmall,
            )
          ],
        ),
      ),
    );
  }
}
