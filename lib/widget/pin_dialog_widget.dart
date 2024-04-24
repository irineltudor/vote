import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class PinDialogBox extends StatefulWidget {
  Function function;
  String pin;
  String text;

  PinDialogBox(
      {super.key,
      required this.function,
      required this.pin,
      required this.text});

  @override
  // ignore: library_private_types_in_public_api
  _PinDialogBoxState createState() => _PinDialogBoxState();
}

class _PinDialogBoxState extends State<PinDialogBox> {
  String enteredPin = '';
  bool isPinVisible = false;
  late String pin = widget.pin;
  late String text = widget.text;

  _PinDialogBoxState();

  Widget numButton(int number, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextButton(
        onPressed: () {
          setState(() {
            if (enteredPin.length < 4) {
              enteredPin += number.toString();
              if (enteredPin.length == 4) {
                if (enteredPin == pin) {
                  Navigator.pop(context);
                  widget.function();
                } else {
                  Fluttertoast.showToast(
                    msg: "Wrong Pin",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                  );
                  setState(() {
                    enteredPin = "";
                  });
                }
              }
            }
          });
        },
        child: Text(
          number.toString(),
          style: theme.textTheme.headlineMedium,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 400),
      decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(45))),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        physics: const BouncingScrollPhysics(),
        children: [
          Center(
            child: Text(
              text,
              style: theme.textTheme.headlineMedium,
            ),
          ),
          const SizedBox(
            height: 10,
          ),

          //pin area
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Container(
                margin: const EdgeInsets.all(6.0),
                width: isPinVisible ? 25 : 16,
                height: isPinVisible ? 35 : 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: index < enteredPin.length
                      ? isPinVisible
                          ? theme.primaryColor
                          : theme.dialogBackgroundColor
                      : theme.primaryColor.withOpacity(0.25),
                ),
                child: isPinVisible && index < enteredPin.length
                    ? Center(
                        child: Text(
                          enteredPin[index],
                          style: theme.textTheme.labelMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      )
                    : null,
              );
            }),
          ),

          // see pin button
          IconButton(
              onPressed: () {
                setState(() {
                  isPinVisible = !isPinVisible;
                });
              },
              icon:
                  Icon(isPinVisible ? Icons.visibility_off : Icons.visibility)),

          for (var i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    3, (index) => numButton(1 + 3 * i + index, theme)).toList(),
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      enteredPin = '';
                    });
                  },
                  child: Icon(
                    Icons.delete,
                    color: theme.dialogBackgroundColor,
                    size: 24,
                  ),
                ),
                numButton(0, theme),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (enteredPin.isNotEmpty) {
                        enteredPin =
                            enteredPin.substring(0, enteredPin.length - 1);
                      }
                    });
                  },
                  child: Icon(
                    Icons.backspace,
                    color: theme.dialogBackgroundColor,
                    size: 24,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// onPressed: () {
//                 Navigator.pop(context);
//                 widget.viewDetails();
//               }