import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vote/screen/more/pin_screen.dart';
import 'package:vote/screen/signup-signin/login_screen.dart';

import '../../widget/menu_widget.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);

    final logoutButton = Container(
      height: height / 15,
      margin: EdgeInsets.symmetric(horizontal: width / 3),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        },
        child: Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: theme.dialogBackgroundColor.withOpacity(0.25),
                    blurRadius: 4)
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
              borderRadius: const BorderRadius.vertical(
                  bottom: const Radius.circular(45)),
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 90, 10, 10),
                color: theme.scaffoldBackgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: theme.dialogBackgroundColor
                                    .withOpacity(0.25),
                                blurRadius: 4)
                          ]),
                      height: height / 8,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListTile(
                              leading: ClipOval(
                                child:
                                    Image.asset("assets/profile/profile.jpg"),
                              ),
                              title: Text("Urma Tudor-Irinel",
                                  style: theme.textTheme.titleLarge
                                      ?.copyWith(color: Colors.white)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Romania",
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                              color: Colors.white
                                                  .withOpacity(0.5))),
                                  Text("23 years old",
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
                            _card(
                                text: 'Set up Pin',
                                icon: Icons.lock,
                                theme: theme,
                                statefulWidget: PinScreen()),
                            _card(
                                text: 'Change Password',
                                icon: Icons.password,
                                theme: theme,
                                statefulWidget: PinScreen())
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _card(
                                text: 'Change Username',
                                icon: Icons.ads_click_outlined,
                                theme: theme,
                                statefulWidget: PinScreen()),
                            _card(
                                text: 'Search ',
                                icon: Icons.search,
                                theme: theme,
                                statefulWidget: PinScreen())
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
                  borderRadius: BorderRadius.all(Radius.circular(45)),
                  color: theme.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                        color: theme.dialogBackgroundColor.withOpacity(0.5),
                        blurRadius: 4)
                  ]),
              padding: const EdgeInsets.only(
                  top: 10, left: 32, right: 32, bottom: 10),
              child: Center(
                child: Text(
                  "More",
                  style: theme.textTheme.titleSmall,
                ),
              )),
        ),
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
                  boxShadow: [
                    BoxShadow(color: theme.dialogBackgroundColor, blurRadius: 1)
                  ]),
              child: MenuWidget(),
            )),
      ]),
    );
  }

  Widget _card(
      {required String text,
      required IconData icon,
      required ThemeData theme,
      required StatefulWidget statefulWidget}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => statefulWidget));
      },
      child: Container(
        height: 160,
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(45)),
            color: theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                  color: theme.dialogBackgroundColor.withOpacity(0.25),
                  blurRadius: 4)
            ]),
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
