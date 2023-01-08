import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uia_app/models/location.dart';
import 'package:uia_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order.dart';

class Globals {
  factory Globals() => _this ??= Globals._();
  Globals._();
  static Globals? _this;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static bool isNetworkAvailable = true;
  static SharedPreferences? sharedPreferences;
  User currentUser = User();
  String? currentRoute;
  Location? currentLocation;
  NotificationAppLaunchDetails? notificationAppLaunchDetails;

  String? currentReferralCode;
}
