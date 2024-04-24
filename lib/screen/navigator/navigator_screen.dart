import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:vote/screen/elections/elections_screen.dart';
import 'package:vote/screen/card/card_screen.dart';
import 'package:vote/screen/more/more_screen.dart';

import '../../item/menu_item.dart';
import '../../model/user.dart';
import '../../service/user_service.dart';
import '../home/home_screen.dart';
import '../menu/menu_screen.dart';
import '../search/search_screen.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  List<MenuItem> menuItem = MenuItems.all;

  UserModel loggedInUser = UserModel();
  final UserService userService = UserService();
  User? user = FirebaseAuth.instance.currentUser;

  int index = 0;
  final screens = [
    const HomeScreen(),
    const ElectionsScreen(),
    const SearchScreen(),
    const CardScreen(),
    const MoreScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: theme.primaryColor,
        color: theme.scaffoldBackgroundColor,
        index: index,
        items: [
          IconTheme(
              data: IconThemeData(color: theme.primaryColor),
              child: const Icon(Icons.home)),
          IconTheme(
              data: IconThemeData(color: theme.primaryColor),
              child: const Icon(Icons.ballot)),
          IconTheme(
              data: IconThemeData(color: theme.primaryColor),
              child: const Icon(Icons.search)),
          IconTheme(
              data: IconThemeData(color: theme.primaryColor),
              child: const Icon(Icons.perm_identity)),
          IconTheme(
              data: IconThemeData(color: theme.primaryColor),
              child: const Icon(Icons.more_horiz)),
        ],
        onTap: (value) => setState(() {
          index = value;
        }),
      ),
      body: Stack(children: <Widget>[
        ZoomDrawer(
          borderRadius: 30,
          angle: -15,
          slideWidth: width / 1.6,
          style: DrawerStyle.defaultStyle,
          showShadow: true,
          shadowLayer1Color: theme.scaffoldBackgroundColor.withOpacity(0.3),
          shadowLayer2Color: theme.scaffoldBackgroundColor.withOpacity(0.6),
          menuBackgroundColor: theme.primaryColor,
          mainScreen: screens[index],
          menuScreen: Builder(builder: (context) {
            return MenuScreen(
                theme: theme,
                currentItem: menuItem[index],
                onSelectedItem: (item) {
                  setState(() {
                    index = menuItem.indexOf(item);
                  });
                  ZoomDrawer.of(context)!.close();
                });
          }),
        ),
      ]),
    );
  }
}
