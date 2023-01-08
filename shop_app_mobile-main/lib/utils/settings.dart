import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uia_app/models/category.dart';
import 'package:uia_app/models/service.dart';
import 'package:path/path.dart' as p;

class Settings {
  Settings._();
  static const String appName = "appname";

  static String? baseUrl;
  static const isAdminApp = false;

  static const httpRequestTimeout = Duration(seconds: 20);
  static bool isTabletMode = false;
  static get isTablet => (context) {
        isTabletMode = MediaQuery.of(context).size.width >= 700;
        return isTabletMode;
      };

  static const String phoneNumberValidatorLogin = r'^[6789]\d{9}$';
  static const String contactNameValidator = r'^[0-9]*$';
  static const String emailValidator = r'\S+@\S+\.\S+';
  static const String passwordValidator = r'^.{6,}$';
  static const String countryCode = "+91";
  static const int waitSecondsForOtpResend = 30;
  static const otpPinLength = 6;

  static const int waitSecondsForOrderCancel = 60;
  static String dynamicLink = "https://liftyplus.page.link";
  static const int pricePerCredit = 5;
  static const int minimumCreditsToBuy = 5;
  static const int minimumWithdrawAmount = 250;

  static List<Map> units = [
    {"title": "Kg", "id": 1},
    {"title": "Litre", "id": 2},
    {"title": "Km", "id": 3},
    {"title": "Visit", "id": 4},
    {"title": "Hour", "id": 5},
    {"title": "Piece", "id": 6},
    {"title": "Purchase", "id": 7},
    {"title": "Service", "id": 8},
    {"title": "Day", "id": 9},
  ];

  static List<Color> categoryColors = [
    Color(0xffB4ECE3),
    Color(0xffFFF8D5),
    Color(0xffC0EDA6),
    Color(0xffFAD9E6),
    Color(0xffC1F4C5),
    Color(0xffFFBED8),
    Color(0xffEEEEEE),
    Color(0xffFFE4C0),
  ];

  static String generateShareMessage(String string) {
    return "Lifty Plus \n Invite professionals to help you whenever and wherever you want \n $string";
  }

  static Color getColorFromString(String color) {
    var hexColor = color.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }

    return Color(int.parse("0x$hexColor"));
  }

  static String randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index) {
      return rand.nextInt(33) + 89;
    });

    return new String.fromCharCodes(codeUnits);
  }

  static List<Locale> locales = [Locale('en','US'),Locale('hi','IN'), Locale('sw','CF'),];
  static List<String> localeStrings = ["English","हिन्दी","kiswahili"];
}
