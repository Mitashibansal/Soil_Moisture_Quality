import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:uia_app/utils/globals.dart';
import 'package:uia_app/utils/notifications.dart';
import 'package:uia_app/utils/settings.dart';

import 'app.view.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.getToken();
  Globals().notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  runApp( EasyLocalization(
      supportedLocales: Settings.locales,
      path: 'assets/translations', // <-- change the path of the translation files 
      fallbackLocale: Settings.locales[0],
      child: MyApp()
    ),);
  // runApp(MyApp());
}
