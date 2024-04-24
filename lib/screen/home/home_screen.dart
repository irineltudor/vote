import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vote/consts.dart';
import 'package:vote/screen/more/pin_screen.dart';
import 'package:vote/screen/verify/verify_intro_screen.dart';
import 'package:vote/service/storage_service.dart';
import 'package:vote/service/user_service.dart';
import 'package:vote/widget/custom_card_widget.dart';

import '../../model/user.dart';
import '../../widget/menu_widget.dart';
import '../../widget/news_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final StorageService storageService = StorageService();
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    userService.getUser(user!.uid).then((value) {
      loggedInUser = value;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);

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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                              "${DateFormat("EEEE").format(DateTime.now())}, ${DateFormat("d MMMM").format(DateTime.now())}",
                              style: theme.textTheme.bodySmall),
                          subtitle: Text("Hello, ${loggedInUser.firstname}",
                              style: theme.textTheme.headlineLarge),
                          trailing: ClipOval(
                              child: FutureBuilder(
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
                                return const CircularProgressIndicator();
                              }

                              return Image.asset("assets/profile/profile.jpg");
                            },
                          )),
                        ),
                      ]),
                ),
              )),
          Positioned(
              top: height * 0.04,
              height: height * 0.05,
              left: 0,
              right: height / 2.5,
              child: const MenuWidget()),
          Positioned(
              top: height * 0.19,
              height: height * 0.7,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: const Radius.circular(45),
                    bottom: const Radius.circular(45)),
                child: Container(
                  color: theme.scaffoldBackgroundColor,
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            border: Border.all(
                                color: theme.dialogBackgroundColor
                                    .withOpacity(0.5),
                                width: 2),
                            boxShadow: ([
                              BoxShadow(
                                  color: theme.dialogBackgroundColor
                                      .withOpacity(0.8),
                                  blurRadius: 1.5)
                            ])),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Account status",
                              style: theme.textTheme.headlineSmall,
                            ),
                            loggedInUser.status == 0
                                ? Row(
                                    children: [
                                      Icon(
                                        Icons.not_interested,
                                        color: Colors.red,
                                      ),
                                      Text(
                                        "Unverified",
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(color: Colors.red),
                                      ),
                                    ],
                                  )
                                : loggedInUser.status == 1
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.verified,
                                            color: Colors.blue,
                                          ),
                                          Text(
                                            "Verified",
                                            style: theme.textTheme.labelMedium
                                                ?.copyWith(color: Colors.blue),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_drop_down_circle,
                                            color: Colors.orange,
                                          ),
                                          Text(
                                            "Waiting",
                                            style: theme.textTheme.labelMedium
                                                ?.copyWith(
                                                    color: Colors.orange),
                                          ),
                                        ],
                                      ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomCardWidget(
                            text: loggedInUser.idCard!['firstname'] != ''
                                ? 'Change ID Card'
                                : 'Add ID Card',
                            icon: Icons.perm_identity,
                            statefulWidget: const VerifyIntroScreen(),
                            pin: pin,
                            function: getData,
                          ),
                          CustomCardWidget(
                            text: 'Set up Pin',
                            icon: Icons.lock,
                            statefulWidget: const PinScreen(),
                            pin: pin,
                            function: getData,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "News",
                            style: theme.textTheme.headlineMedium,
                          ),
                          GestureDetector(
                            onTap: () => {},
                            child: Text(
                              "Politics",
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    NewsSlider(),
                  ]),
                ),
              )),
        ]),
      );
    }
  }
}
