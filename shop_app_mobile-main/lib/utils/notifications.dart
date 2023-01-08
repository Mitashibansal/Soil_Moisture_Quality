import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uia_app/utils/globals.dart';
import 'package:uia_app/utils/logger.dart';
import 'package:uia_app/utils/pages.dart';
import 'package:uia_app/utils/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NoticationsHelper {
  final log = getLogger('notification_helper');
  BuildContext? context;
  initialise({BuildContext? context}) async {
    context = context;

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    // var initializationSettingsIOS =  IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    FlutterLocalNotificationsPlugin().initialize(initializationSettings,
        // );
        onDidReceiveNotificationResponse: onNotificationPressed,
        onDidReceiveBackgroundNotificationResponse: onNotificationPressed);

    setMessageListeners();
  }

  setMessageListeners() {
    try {
      FirebaseMessaging.onBackgroundMessage(myForgroundMessageHandler);
      FirebaseMessaging.onMessage.listen((event) {
        print("event");
        myForgroundMessageHandler(event);
      });
    } catch (e) {
      print(e);
    }
  }

  static openScreen(orderId, {BuildContext? context}) {
    print('opening screen... additional data $orderId');

    Globals().navigatorKey.currentState!.pushNamed(Pages.orderRequest,
        arguments: Order(id: int.tryParse(orderId)));
    // Navigator.pushNamed(context, Pages.newRequestScreen, arguments: order);
    print('okay2');
    // proceed(additionalData, context: context);

    print('okay');
  }

  @pragma('vm:entry-point')
  static onNotificationPressed(NotificationResponse? notificationResponse) {
    String? payload = notificationResponse?.payload;
    print('notification pressed $payload');
    List<String> pay = payload!.split(",");
    if (pay[1] != "" && pay[0] == "new_order") openScreen(pay[1]);
  }
}

Future<dynamic> myForgroundMessageHandler(
  RemoteMessage message,
) async {
  print('notification');
  print(message);

  // print(message.notification.title);

  var title = message.data['title'] ?? '';
  var body = message.data['body'] ?? '';
  var screen = message.data['screen'] ?? '';
  var id = message.data['type_id'] ?? '';

  generateSimpleNotication(title, body, screen, id);
}

Future<void> generateSimpleNotication(
    String title, String msg, String screen, String id) async {
  var androidPlatformChannelSpecifics;
  // Globals.sharedPreferences = await SharedPreferences.getInstance();
  // String? selectedTone =
  //     Globals.sharedPreferences!.getString(Preferences.notificationTone);
  // print('selected tone $selectedTone');
  if (screen == "new_order") {
    androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        // selectedTone ?? tones.first['fileName'], //channel id
        'neworder',
        'New Order',
        importance: Importance.max,
        priority: Priority.high,
        channelAction: AndroidNotificationChannelAction.createIfNotExists,
        playSound: true,
        sound: RawResourceAndroidNotificationSound("new_order"));
  } else {
    androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      // selectedTone ?? tones.first['fileName'], //channel id
      'general',
      'General',
      importance: Importance.max,
      priority: Priority.high,
      channelAction: AndroidNotificationChannelAction.createIfNotExists,
      playSound: true,
    );
  }

  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
      1, title, msg, platformChannelSpecifics,
      payload: (screen ?? '') + "," + (id ?? ""));
  print('notiffy ${(screen ?? '') + "," + (id ?? "")}');
}
