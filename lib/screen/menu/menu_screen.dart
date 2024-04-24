import 'package:flutter/material.dart';

import '../../item/menu_item.dart';

class MenuItems {
  static const home = MenuItem('Home', Icons.home);
  static const ballots = MenuItem('Ballot', Icons.ballot);
  static const search = MenuItem('Search', Icons.search);
  static const idCard = MenuItem('Card', Icons.perm_identity);
  static const settings = MenuItem('More', Icons.more_horiz);

  static const all = <MenuItem>[home, ballots, search, idCard, settings];
}

class MenuScreen extends StatelessWidget {
  final MenuItem currentItem;
  final ValueChanged<MenuItem> onSelectedItem;
  final ThemeData theme;

  const MenuScreen(
      {super.key,
      required this.currentItem,
      required this.onSelectedItem,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Container(
            width: 100,
            margin: const EdgeInsets.only(left: 15),
            child: Image.asset(
              isDarkMode
                  ? "assets/logo/dark/logo.png"
                  : "assets/logo/light/logo.png",
            ),
          ),
          ...MenuItems.all.map(buildMenuItem),
          const Spacer(flex: 2),
        ],
      )),
    );
  }

  Widget buildMenuItem(MenuItem item) {
    return ListTileTheme(
      selectedColor: theme.primaryColor,
      child: ListTile(
        selectedTileColor: theme.scaffoldBackgroundColor,
        selected: currentItem == item,
        minLeadingWidth: 20,
        leading: Icon(item.icon),
        title: Text(item.title),
        textColor: theme.scaffoldBackgroundColor,
        iconColor: theme.scaffoldBackgroundColor,
        onTap: () => onSelectedItem(item),
      ),
    );
  }
}
