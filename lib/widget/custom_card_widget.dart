import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:vote/screen/more/pin_screen.dart';

import 'pin_dialog_widget.dart';

class CustomCardWidget extends StatefulWidget {
  String text;
  IconData icon;
  StatefulWidget statefulWidget;
  String pin;
  Future<void> function;

  CustomCardWidget(
      {required this.text,
      required this.icon,
      required this.statefulWidget,
      required this.pin,
      required this.function});

  @override
  State<CustomCardWidget> createState() => _CustomCardWidgetState();
}

class _CustomCardWidgetState extends State<CustomCardWidget> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String text = widget.text;
    IconData icon = widget.icon;
    StatefulWidget statefulWidget = widget.statefulWidget;
    String pin = widget.pin;
    return GestureDetector(
      onTap: () async {
        pin != ""
            ? showDialog(
                context: context,
                barrierColor: Colors.black38,
                builder: (BuildContext context) {
                  return PinDialogBox(
                    function: () async {
                      String refresh = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => statefulWidget));
                      if (refresh == "refresh") {
                        widget.function;
                        print("aici");
                      }
                    },
                    pin: pin,
                    text: "Enter your pin",
                  );
                })
            : await Navigator.push(context,
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
