import 'package:flutter/material.dart';

import 'pin_dialog_widget.dart';

class TwoFactorCardWidget extends StatefulWidget {
  final String text;
  final IconData icon;
  final StatefulWidget statefulWidget;
  final String pin;
  final Function function;

  const TwoFactorCardWidget(
      {super.key,
      required this.text,
      required this.icon,
      required this.statefulWidget,
      required this.pin,
      required this.function});

  @override
  State<TwoFactorCardWidget> createState() => _TwoFactorCardWidgetState();
}

class _TwoFactorCardWidgetState extends State<TwoFactorCardWidget> {
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
                      String? refresh = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => statefulWidget));
                      if (refresh == "refresh") {
                        widget.function.call();
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
        height: 40,
        width: 200,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            border: Border.all(
                color: theme.dialogBackgroundColor.withOpacity(0.5), width: 2),
            boxShadow: ([
              BoxShadow(
                  color: theme.dialogBackgroundColor.withOpacity(0.8),
                  blurRadius: 1.5)
            ])),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: theme.primaryColor,
              size: 20,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              text,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
