import 'dart:convert';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:uia_app/models/category.dart';
import 'package:uia_app/models/product.dart';
import 'package:uia_app/models/staff.dart';
import 'package:uia_app/models/user.dart';
import 'package:uia_app/models/withdrawal_request.dart';
import 'package:uia_app/utils/endpoints.dart';
import 'package:uia_app/utils/globals.dart';
import 'package:uia_app/utils/http_helper.dart';
import 'package:uia_app/utils/logger.dart';
import 'package:uia_app/utils/pages.dart';
import 'package:uia_app/utils/settings.dart';

class AdminRepository {
  factory AdminRepository() => _this ??= AdminRepository._();
  AdminRepository._();
  static AdminRepository? _this;

  final log = getLogger('auth_repository');

  final httpHelper = new HttpHelper();

  login(User user, bool? isResend) async {
    String? firebaseToken = await FirebaseMessaging.instance.getToken();
    var data = {
      "mobile": user.phone,
      "firebase_token": firebaseToken,
    };
    return await httpHelper.request(HttpMethods.post,
        endPoint: Endpoints.adminLogin, data: json.encode(data));
  }

  createProduct(Product product) async {
    var data = product.toJson();
    return await httpHelper.request(HttpMethods.post,
        authenticationRequired: true,
        endPoint: Endpoints.createProduct,
        data: json.encode(data));
  }

  createCategory(Category category) async {
    var data = category.toJson();
    return await httpHelper.request(HttpMethods.post,
        authenticationRequired: true,
        endPoint: Endpoints.createCategories,
        data: json.encode(data));
  }

  getDashBoardData() async {
    return await httpHelper.request(
      HttpMethods.get,
      authenticationRequired: true,
      endPoint: Endpoints.getDashboard(Globals().currentUser.id ?? 0),
    );
  }

  createStaff(Staff staff) async {
    var data = staff.toJson();
    return await httpHelper.request(HttpMethods.post,
        authenticationRequired: true,
        endPoint: Endpoints.createStaff,
        data: json.encode(data));
  }

  getProducts() async {
    return await httpHelper.request(
      HttpMethods.get,
      authenticationRequired: true,
      endPoint: Endpoints.getProducts,
    );
  }

  getCategories() async {
    return await httpHelper.request(
      HttpMethods.get,
      authenticationRequired: true,
      endPoint: Endpoints.getCategories,
    );
  }

  startFirebaseAnalytics() async {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics.setUserId(
      id: Globals().currentUser.id.toString(),
    );
    await analytics.setUserProperty(
      name: 'name',
      value: Globals().currentUser.name,
    );
  }

  logEventInAnalytics(String name, {Map<String, dynamic>? data}) {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics.logEvent(name: name, parameters: data);
  }

  Future<String?> getDeviceId() async {
    // String? identifier;
    // final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    // try {
    //   if (Platform.isAndroid) {
    //     var build = await deviceInfoPlugin.androidInfo;
    //     // identifier = build.androidId; //UUID for Android
    //   } else if (Platform.isIOS) {
    //     var data = await deviceInfoPlugin.iosInfo;

    //     identifier = data.identifierForVendor; //UUID for iOS
    //   }
    // } catch (e) {
    //   log.e(e, "getDeviceId");
    // }
    return "identifier";
  }

  // userLoggedIn() async {
  //   await Globals.sharedPreferences.setInt(
  //       Preferences.messagesLastUpdatedTimeInSeconds,
  //       DateTimeHelper.getCurrentTimeInMilliSeconds() ~/
  //           1000); //store as seconds as buddypress default is in seconds
  //   int userId = Globals.sharedPreferences.getInt(Preferences.userId);
  //   // Crashlytics.instance.setString('userId', userId.toString());
  //   // Crashlytics.instance.setUserIdentifier(userId.toString());
  //   // var notificationSetId =
  //   //     await OneSignal.shared.setExternalUserId(userId.toString());
  //   // log.d('notificationSetId $notificationSetId');
  // }

  getConfig() async {
    return await httpHelper.request(
      HttpMethods.get,
      authenticationRequired: false,
      baseUrl: Endpoints.config,
    );
  }

  logout() async {
    await Globals.sharedPreferences?.clear();

    FirebaseMessaging.instance.deleteToken();
    Globals().currentUser = User();
    Globals()
        .navigatorKey
        .currentState
        ?.pushNamedAndRemoveUntil(Pages.login, (Route<dynamic> route) => false);
  }
}
