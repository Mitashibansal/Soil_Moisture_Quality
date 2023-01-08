import 'package:flutter/material.dart';

ThemeData themeData(Color? primaryColor) {
  return ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.light,
    // primaryColor: AppColors.blue,
    primaryColor: primaryColor,

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // onPrimary: Colors.yellow,
        primary: primaryColor,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
    ),
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(backgroundColor: primaryColor),

    // Define the default font family.
    fontFamily: 'WorkSans',

    // Define the default `TextTheme`. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: const TextTheme(
        // headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        // headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        // bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
  );
}

class AppColors {
  AppColors._();

  static const Color success = Colors.green;
  static const blue = Color(0xff2155D9);
  static const lightYellow = Color(0xfffff9d7);
  static const Color textColorBlack = Colors.black;
  static const Color textColorGrey = Color(0xff9696A0);
  static const Color lightGrey = Color(0xffBEBEBE);
  static const Color darkyellow = Color(0xffe9c332);
  static const Color orange = Color(0xffFF9820);

  // static const Color primaryColor = Color(0xff00838F); //1
  // static const Color primaryColor = Color(0xff2E3712); //2
  // static const Color primaryColor = Color(0xff4A148C); //3
  // static const Color primaryColor = Color(0xff006064); //4
  // static const Color primaryColor = Color(0xff404223); //5
  // static const Color primaryColor = Color(0xff3EB489); //6
  // static const Color primaryColor = Color(0xff9900F0); //7
  // static const Color primaryColor = Color(0xff3F0713); //8
  // static const Color primaryColor = Color(0xff630606); //9
  // static const Color primaryColor = Color(0xffF0A500); //10

  static const Color primaryColor = Color(0xff407BFF); //9
  static const Color loginPrimaryColor = Color(0xffF7EBE1);
  static const Color loginButtonColor = Color(0xff132137);
  static const Color background = Color(0xFFF2F3F8);
  static const Color darkerText = Color(0xFF17262A);

  static const Color pendingColor = Color(0xFFFBC02D);
  static const Color confirmedColor = Colors.lightGreen;
  static const Color deliveredColor = Colors.green;
  static Color flushbarColorRegular = Color(0xFF303030);
}

class FontSizes {
  static const double buttonText1 = 20;
  static const double regularText = 16;
}
