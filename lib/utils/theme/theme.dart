import 'package:flutter/material.dart';
import 'package:vote/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:vote/utils/theme/custom_themes/icon_theme.dart';
import 'package:vote/utils/theme/custom_themes/list_tile_theme.dart';
import 'package:vote/utils/theme/custom_themes/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.light,
      primaryColor: const Color.fromARGB(255, 0, 122, 223),
      scaffoldBackgroundColor: Colors.white,
      dialogBackgroundColor: Colors.black,
      textTheme: TTextTheme.lightTextTheme,
      elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
      iconTheme: TIconTheme.lightIconTheme,
      listTileTheme: TListTileTheme.lightListTileTheme,
      package: "assets/logo/light");
  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      primaryColor: const Color.fromARGB(255, 0, 122, 223),
      dialogBackgroundColor: Colors.white,
      scaffoldBackgroundColor: const Color.fromARGB(255, 48, 48, 48),
      textTheme: TTextTheme.darkTextTheme,
      elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
      iconTheme: TIconTheme.darkIconTheme,
      listTileTheme: TListTileTheme.darkListTileTheme,
      package: "assets/logo/dark");
}
