import 'package:flutter/material.dart';

import '../../item/menu_item.dart';

class MenuItems {
  static const home = MenuItem('Home', Icons.home);
  static const search = MenuItem('Search', Icons.search);
  static const ballots = MenuItem('Ballot', Icons.ballot);
  static const idCard = MenuItem('Card', Icons.perm_identity);
  static const settings = MenuItem('More', Icons.more_horiz);

  static const all = <MenuItem>[home, search, ballots, idCard, settings];
}

class MenuScreen extends StatelessWidget {
  final MenuItem currentItem;
  final ValueChanged<MenuItem> onSelectedItem;
  final ThemeData theme;

  const MenuScreen(
      {Key? key,
      required this.currentItem,
      required this.onSelectedItem,
      required this.theme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(),
          ...MenuItems.all.map(buildMenuItem).toList(),
          Spacer(flex: 2),
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
