import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:vote/screen/elections/elections_screen.dart';
import 'package:vote/screen/card/card_screen.dart';
import 'package:vote/screen/more/more_screen.dart';

import '../../item/menu_item.dart';
import '../../widget/menu_widget.dart';
import '../home/home_screen.dart';
import '../menu/menu_screen.dart';
import '../search/search_screen.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  List<MenuItem> menuItem = MenuItems.all;

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
    final height = MediaQuery.of(context).size.height;
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
          slideWidth: width / 1.75,
          style: DrawerStyle.Style1,
          showShadow: true,
          backgroundColor: Color.fromARGB(115, 0, 0, 0),
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
