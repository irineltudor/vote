import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vote/screen/more/account_details_screen.dart';
import 'package:vote/screen/more/change_password_screen.dart';
import 'package:vote/screen/more/pin_screen.dart';
import 'package:vote/screen/signup-signin/login_screen.dart';

import '../../model/user.dart';
import '../../service/storage_service.dart';
import '../../service/user_service.dart';
import '../../widget/custom_card_widget.dart';
import '../../widget/menu_widget.dart';
import '../verify/verify_intro_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  UserModel loggedInUser = UserModel();
  User? user = FirebaseAuth.instance.currentUser;
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

      DateTime today = DateTime.now();
      DateTime date = DateFormat('MM-dd-yyyy').parse(loggedInUser.dob!);

      int age = (today.difference(date).inDays / 365).floor();

      final logoutButton = Container(
        height: height / 15,
        margin: EdgeInsets.symmetric(horizontal: width / 3),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: const [
                  BoxShadow(color: Color.fromARGB(246, 0, 0, 0), blurRadius: 4)
                ],
                color: theme.primaryColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Log out',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: theme.scaffoldBackgroundColor),
                ),
                const SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.logout,
                  color: theme.scaffoldBackgroundColor,
                )
              ],
            ),
          ),
        ),
      );

      return Scaffold(
        backgroundColor: theme.primaryColor,
        body: Stack(children: <Widget>[
          Positioned(
              top: 0,
              height: height * 0.89,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(45)),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 90, 10, 10),
                  color: theme.scaffoldBackgroundColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromARGB(246, 0, 0, 0),
                                  blurRadius: 4)
                            ]),
                        height: height / 8,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ListTile(
                                leading: ClipOval(
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

                                      return Image.asset(
                                          "assets/profile/profile.jpg");
                                    },
                                  ),
                                ),
                                title: Text(
                                    "${loggedInUser.lastname} ${loggedInUser.firstname}",
                                    style: theme.textTheme.titleLarge
                                        ?.copyWith(color: Colors.white)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        loggedInUser.idCard!["country"] == ""
                                            ? "Country not available"
                                            : loggedInUser.idCard!["country"],
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                                color: Colors.white
                                                    .withOpacity(0.5))),
                                    Text("$age years old",
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                                color: Colors.white
                                                    .withOpacity(0.5)))
                                  ],
                                ),
                              ),
                            ]),
                      ),
                      Column(
                        children: [
                          Row(
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
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CustomCardWidget(
                                text: 'Change Password',
                                icon: Icons.password,
                                statefulWidget: const ChangePasswordScreen(),
                                pin: pin,
                                function: getData,
                              ),
                              CustomCardWidget(
                                text: 'Account details',
                                icon: Icons.edit,
                                statefulWidget: const AccountDetailsScreen(),
                                pin: pin,
                                function: getData,
                              )
                            ],
                          )
                        ],
                      ),
                      logoutButton
                    ],
                  ),
                ),
              )),
          Positioned(
            top: height * 0.03,
            height: height * 0.07,
            left: 5,
            right: 5,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(45)),
                    color: theme.scaffoldBackgroundColor,
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(0, 0, 0, 0), blurRadius: 2)
                    ]),
                padding: const EdgeInsets.only(
                    top: 10, left: 32, right: 32, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.more_horiz,
                      color: theme.dialogBackgroundColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "More",
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
}
