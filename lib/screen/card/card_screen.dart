import 'dart:collection';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_flags/country_flags.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blur/blur.dart';
import 'package:vote/widget/pin_dialog_widget.dart';
import 'dart:math' show pi;

import '../../consts.dart';
import '../../model/user.dart';
import '../../service/storage_service.dart';
import '../../service/user_service.dart';
import '../../widget/menu_widget.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  bool personalDetails = false;
  double verticalDrag = 0;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final StorageService storageService = StorageService();
  final UserService userService = UserService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    controller.addListener(() {
      setState(() {
        verticalDrag = controller.value * 3;
      });
    });
  }

  Future<void> getData() async {
    userService.getUser(user!.uid).then((value) {
      loggedInUser = value;
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> viewDetails() async {
    personalDetails ? controller.reverse() : controller.forward();
    setState(() {
      personalDetails = !personalDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);

    print("Aici");
    if (loggedInUser.firstname == null) {
      return Container(
          color: theme.primaryColor,
          child: Center(
              child: CircularProgressIndicator(
            color: theme.scaffoldBackgroundColor,
          )));
    } else {
      String pin = loggedInUser.pin!;
      return Scaffold(
        backgroundColor: theme.primaryColor,
        body: Stack(children: <Widget>[
          Positioned(
              top: 0,
              height: height * 0.89,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    bottom: const Radius.circular(45)),
                child: Container(
                    padding: EdgeInsets.fromLTRB(10, 90, 10, 10),
                    color: theme.scaffoldBackgroundColor,
                    child: loggedInUser.idCard!["country"] == ""
                        ? Center(
                            child: Text('No id card assigned',
                                style: theme.textTheme.headlineSmall),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Transform(
                                  transform: Matrix4.identity()
                                    ..rotateY(verticalDrag),
                                  alignment: Alignment.center,
                                  child: personalDetails
                                      ? Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(pi),
                                          child: _idCard(
                                              theme: theme,
                                              idCard: loggedInUser.idCard!))
                                      : _idCard(
                                          theme: theme,
                                          idCard: loggedInUser.idCard!)),
                              GestureDetector(
                                onTap: () {
                                  personalDetails ? openDialog(theme) : null;
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  decoration: BoxDecoration(
                                    color: personalDetails
                                        ? Colors.red
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color.fromARGB(246, 0, 0, 0),
                                          spreadRadius: 1,
                                          blurRadius: 5)
                                    ],
                                  ),
                                  child: personalDetails
                                      ? Icon(Icons.delete, color: Colors.white)
                                      : Icon(Icons.delete,
                                          color: Colors.white.withOpacity(0.5)),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  personalDetails
                                      ? viewDetails()
                                      : pin != ''
                                          ? showDialog(
                                              context: context,
                                              barrierColor: Colors.black38,
                                              builder: (BuildContext context) {
                                                return PinDialogBox(
                                                  function: () {
                                                    viewDetails();
                                                  },
                                                  pin: pin,
                                                  text: "Enter your pin",
                                                );
                                              })
                                          : viewDetails();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  margin: EdgeInsets.symmetric(vertical: 60),
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color.fromARGB(246, 0, 0, 0),
                                          spreadRadius: 1,
                                          blurRadius: 5)
                                    ],
                                  ),
                                  child: personalDetails
                                      ? Icon(Icons.visibility,
                                          color: Colors.white)
                                      : Icon(Icons.visibility_off,
                                          color: Colors.white),
                                ),
                              ),
                            ],
                          )),
              )),
          Positioned(
            top: height * 0.03,
            height: height * 0.07,
            left: 5,
            right: 5,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(45)),
                  color: theme.scaffoldBackgroundColor,
                ),
                padding: const EdgeInsets.only(
                    top: 10, left: 32, right: 32, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      color: theme.dialogBackgroundColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Identification card",
                      style: theme.textTheme.headlineMedium,
                    ),
                  ],
                )),
          ),
          Positioned(
              top: height * 0.04,
              height: height * 0.05,
              left: 0,
              right: height / 2.5,
              child: const MenuWidget()),
        ]),
      );
    }
  }

  Widget _idCard(
      {required ThemeData theme, required Map<String, dynamic> idCard}) {
    return Container(
      width: 360,
      height: 250,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(color: Color.fromARGB(246, 0, 0, 0), blurRadius: 4)
          ]),
      child: Column(children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
            child: Row(children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(25))),
                    child: showFlag(
                        CountryFlag.fromCountryCode(
                            idCard["country"].toLowerCase().substring(0, 2)),
                        theme.textTheme.headlineMedium!,
                        theme.scaffoldBackgroundColor),
                  )),
              Expanded(
                  flex: 3,
                  child: Container(
                    margin:
                        const EdgeInsets.only(left: 10.0, right: 20.0, top: 1),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Country",
                                style: theme.textTheme.labelLarge,
                              ),
                              Text(
                                "Identification Card",
                                style: theme.textTheme.labelLarge,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              child: Divider(
                            color: theme.dialogBackgroundColor,
                            thickness: 1.5,
                          )),
                        ),
                        Expanded(
                            flex: 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                showPersonalDetails(
                                    idCard["country"],
                                    theme.textTheme.labelSmall!,
                                    theme.scaffoldBackgroundColor),
                              ],
                            ))
                      ],
                    ),
                  )),
            ]),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            child: Row(children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder(
                        future: storageService.getProfilePicture(
                          loggedInUser.uid!,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return Image.network(
                              snapshot.data!,
                            );
                          }
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              !snapshot.hasData) {
                            return CircularProgressIndicator();
                          }

                          return Image.asset("assets/profile/profile.jpg");
                        },
                      ),
                      showPersonalDetails(
                          '${idCard["lastname"]} ${idCard["firstname"]}',
                          theme.textTheme.labelSmall!,
                          theme.scaffoldBackgroundColor),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 20, 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal Code',
                              style: theme.textTheme.labelLarge,
                            ),
                            showPersonalDetails(
                                idCard["personalCode"],
                                theme.textTheme.labelSmall!,
                                theme.scaffoldBackgroundColor),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Address',
                                  style: theme.textTheme.labelLarge,
                                ),
                                showPersonalDetails(
                                    '${idCard["county"]}, ${idCard["city"]}, ${idCard["address"]}',
                                    theme.textTheme.labelSmall!,
                                    theme.scaffoldBackgroundColor),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sex',
                                  style: theme.textTheme.labelLarge,
                                ),
                                showPersonalDetails(
                                    idCard["sex"],
                                    theme.textTheme.labelSmall!,
                                    theme.scaffoldBackgroundColor),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nationality',
                                  style: theme.textTheme.labelLarge,
                                ),
                                showPersonalDetails(
                                    idCard["nationality"],
                                    theme.textTheme.labelSmall!,
                                    theme.scaffoldBackgroundColor),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date of birth',
                                  style: theme.textTheme.labelLarge,
                                ),
                                showPersonalDetails(
                                    idCard["dob"],
                                    theme.textTheme.labelSmall!,
                                    theme.scaffoldBackgroundColor),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Valability',
                              style: theme.textTheme.labelLarge,
                            ),
                            showPersonalDetails(
                                "${idCard["issueDate"]} - ${idCard["expireDate"]}",
                                theme.textTheme.labelSmall!,
                                theme.scaffoldBackgroundColor),
                          ],
                        ),
                      ]),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget showPersonalDetails(String detail, TextStyle style, Color color) {
    return personalDetails
        ? Text(
            detail,
            style: style,
          )
        : Blur(
            blur: 2.1,
            blurColor: color,
            child: Text(
              'x' * detail.length,
              style: style,
            ),
          );
  }

  Widget showFlag(CountryFlag countryFlag, TextStyle style, Color color) {
    return personalDetails
        ? countryFlag
        : Blur(
            blur: 5,
            blurColor: color,
            child: Center(
              child: Text(
                'XXX\n',
                style: style,
              ),
            ),
          );
  }

  Future openDialog(ThemeData theme) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.primaryColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Are you sure?",
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: theme.scaffoldBackgroundColor),
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                userService.deleteIdCard(loggedInUser);
                Navigator.pop(context);
                if (mounted) {
                  setState(() {});
                }
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(theme.scaffoldBackgroundColor),
              ),
              child: Text(
                "Delete",
                style: theme.textTheme.bodyLarge!.copyWith(color: Colors.red),
              ),
            ),
          )
        ],
      ),
    );
  }
}
