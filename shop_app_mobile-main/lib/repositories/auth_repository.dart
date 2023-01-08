import 'dart:convert';
import 'dart:io';

// import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:uia_app/models/staff.dart';
import 'package:uia_app/models/user.dart';
import 'package:uia_app/models/withdrawal_request.dart';
import 'package:uia_app/utils/endpoints.dart';
import 'package:uia_app/utils/globals.dart';
import 'package:uia_app/utils/http_helper.dart';
import 'package:uia_app/utils/logger.dart';
import 'package:uia_app/utils/pages.dart';
import 'package:uia_app/utils/settings.dart';

class AuthRepository {
  factory AuthRepository() => _this ??= AuthRepository._();
  AuthRepository._();
  static AuthRepository? _this;

  final log = getLogger('auth_repository');

  final httpHelper = new HttpHelper();

  sendOtp(User user, bool? isResend) async {
    var data = user.toMapForLogin(isResend: isResend);
    return await httpHelper.request(HttpMethods.post,
        endPoint: Endpoints.checkUser, data: json.encode(data));
  }

  initiateUserVerification(
    User user,
  ) async {
    String? firebaseToken = await FirebaseMessaging.instance.getToken();

    var data = {"mobile": user.phone, "firebase_token": firebaseToken};
    if (user.isNewUser) {
      data['name'] = user.name;
    }

    return await httpHelper.request(HttpMethods.post,
        endPoint: Endpoints.otpVerification(), data: json.encode(data));
  }

  getProfile() async {
    return await httpHelper.request(
      HttpMethods.get,
      authenticationRequired: true,
      endPoint: Endpoints.getProfile(Globals().currentUser.id ?? 0),
    );
  }

  getProfileByPhone(String phone) async {
    return await httpHelper.request(
      HttpMethods.get,
      authenticationRequired: false,
      endPoint: Endpoints.getProfileByPhone(phone),
    );
  }

  getProfileByReferralCode(String referralCode) async {
    return await httpHelper.request(
      HttpMethods.get,
      authenticationRequired: false,
      endPoint: Endpoints.getProfileByReferralCode(referralCode),
    );
  }

  getDashBoardData() async {
    return await httpHelper.request(
      HttpMethods.get,
      authenticationRequired: true,
      endPoint: Endpoints.getDashboard(Globals().currentUser.id ?? 0),
    );
  }

  saveProfile(User? user) async {
    var data = user?.toMapForUpdate();
    return await httpHelper.request(HttpMethods.put,
        authenticationRequired: true,
        endPoint: Endpoints.saveProfile(Globals().currentUser.id ?? 0),
        data: json.encode(data));
  }

  getReferrals() async {
    return await httpHelper.request(
      HttpMethods.get,
      authenticationRequired: true,
      endPoint: Endpoints.getReferrals,
    );
  }

  getPaymentToken(Map? data) async {
    return await httpHelper.request(HttpMethods.post,
        authenticationRequired: true,
        endPoint: Endpoints.createCreditBuyOrder,
        data: json.encode(data));
  }

  verifyPayment(Map? data) async {
    return await httpHelper.request(HttpMethods.post,
        authenticationRequired: true,
        endPoint: Endpoints.verifyPayment,
        data: json.encode(data));
  }

  transferCredit(Map? data) async {
    return await httpHelper.request(HttpMethods.post,
        authenticationRequired: true,
        endPoint: Endpoints.transferCredit,
        data: json.encode(data));
  }

  getCreditHistory() async {
    return await httpHelper.request(
      HttpMethods.get,
      authenticationRequired: true,
      endPoint: Endpoints.getCreditHistory,
    );
  }

  getTodaysIncome() async {
    return await httpHelper.request(
      HttpMethods.get,
      authenticationRequired: true,
      endPoint: Endpoints.getTodaysIncome,
    );
  }

  createStaff(Staff staff) async {
    var data = staff.toJson();
    return await httpHelper.request(HttpMethods.post,
        authenticationRequired: true,
        endPoint: Endpoints.createStaff,
        data: json.encode(data));
  }

  getStaffs() async {
    return await httpHelper.request(
      HttpMethods.get,
      authenticationRequired: true,
      endPoint: Endpoints.getStaffs,
    );
  }

  createWithdrawalRequest(WithdrawalRequest request) async {
    var data = request.toJson();
    return await httpHelper.request(HttpMethods.post,
        authenticationRequired: true,
        endPoint: Endpoints.requestWithdrawal,
        data: json.encode(data));
  }

  getPendingWithdrawals() async {
    return await httpHelper.request(
      HttpMethods.get,
      authenticationRequired: true,
      endPoint: Endpoints.getPendingWithdrawals,
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
