import 'package:flutter/material.dart';

class TTextTheme {
  TTextTheme._();

  //Light Theme
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: 'KanitRegular'),
    headlineMedium: const TextStyle().copyWith(
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontFamily: 'KanitRegular'),
    headlineSmall: const TextStyle().copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: Colors.black,
        fontFamily: 'KanitRegular'),
    titleLarge: const TextStyle().copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontFamily: 'KanitRegular'),
    titleMedium: const TextStyle().copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        fontFamily: 'KanitRegular'),
    titleSmall: const TextStyle().copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: Colors.black,
        fontFamily: 'KanitRegular'),
    bodyLarge: const TextStyle().copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        fontFamily: 'KanitRegular'),
    bodyMedium: const TextStyle().copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: Colors.black,
        fontFamily: 'KanitRegular'),
    bodySmall: const TextStyle().copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: Colors.black.withOpacity(0.5),
        fontFamily: 'KanitRegular'),
    labelLarge: const TextStyle().copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: 'KanitRegular'),
    labelMedium: const TextStyle().copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
        color: Colors.black.withOpacity(0.5),
        fontFamily: 'KanitRegular'),
  );

  //Dark Theme
  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: 'KanitRegular'),
    headlineMedium: const TextStyle().copyWith(
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: 'KanitRegular'),
    headlineSmall: const TextStyle().copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: Colors.white,
        fontFamily: 'KanitRegular'),
    titleLarge: const TextStyle().copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: 'KanitRegular'),
    titleMedium: const TextStyle().copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        fontFamily: 'KanitRegular'),
    titleSmall: const TextStyle().copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: Colors.white,
        fontFamily: 'KanitRegular'),
    bodyLarge: const TextStyle().copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        fontFamily: 'KanitRegular'),
    bodyMedium: const TextStyle().copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: Colors.white,
        fontFamily: 'KanitRegular'),
    bodySmall: const TextStyle().copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: Colors.white.withOpacity(0.5),
        fontFamily: 'KanitRegular'),
    labelLarge: const TextStyle().copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: 'KanitRegular'),
    labelMedium: const TextStyle().copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
        color: Colors.white.withOpacity(0.5),
        fontFamily: 'KanitRegular'),
  );
}
