import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vote/service/user_service.dart';
import 'package:vote/widget/pin_dialog_widget.dart';

import '../../model/user.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String enteredPin = '';
  bool isPinVisible = false;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    userService.getUser(user!.uid).then((value) {
      loggedInUser = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    if (loggedInUser.firstname == null) {
      return Container(
          color: theme.primaryColor,
          child: Center(
              child: CircularProgressIndicator(
            color: theme.scaffoldBackgroundColor,
          )));
    } else {
      return Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: theme.scaffoldBackgroundColor,
            ),
            onPressed: () {
              // passing this to our root
              Navigator.of(context).pop();
            },
          ),
          title: Container(
            margin: EdgeInsets.only(left: 80),
            child: Text(
              "Update Pin",
              style: theme.textTheme.headlineMedium
                  ?.copyWith(color: theme.scaffoldBackgroundColor),
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(45))),
          child: Center(
            child: Container(
              margin: EdgeInsets.all(10),
              height: 450,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(45))),
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                physics: const BouncingScrollPhysics(),
                children: [
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
                      icon: Icon(isPinVisible
                          ? Icons.visibility_off
                          : Icons.visibility)),

                  for (var i = 0; i < 3; i++)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(3,
                                (index) => numButton(1 + 3 * i + index, theme))
                            .toList(),
                      ),
                    ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
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
                                enteredPin = enteredPin.substring(
                                    0, enteredPin.length - 1);
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
            ),
          ),
        ),
      );
    }
  }

  Widget numButton(int number, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextButton(
        onPressed: () {
          setState(() {
            if (enteredPin.length < 4) {
              enteredPin += number.toString();
              if (enteredPin.length == 4) {
                showDialog(
                    context: context,
                    barrierColor: Colors.black38,
                    builder: (BuildContext context) {
                      return PinDialogBox(
                          function: () async {
                            Fluttertoast.showToast(
                              msg: "Pin Updated",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.SNACKBAR,
                            );
                            userService.updatePin(loggedInUser, enteredPin);
                            Navigator.of(context).pop("refresh");
                            setState(() {});
                          },
                          pin: enteredPin,
                          text: "Confirm pin");
                    });
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
}
