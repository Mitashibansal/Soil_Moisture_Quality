import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:uia_app/models/user.dart';
import 'package:uia_app/repositories/auth_repository.dart';
import 'package:uia_app/repositories/order_repository.dart';
import 'package:uia_app/utils/custom_exceptions.dart';
import 'package:uia_app/utils/globals.dart';
import 'package:uia_app/utils/http_helper.dart';
import 'package:uia_app/utils/internet_connectivity_listener.dart';
import 'package:uia_app/utils/pages.dart';
import 'package:uia_app/utils/preferences.dart';
import 'package:uia_app/utils/settings.dart';
import 'package:uia_app/utils/version_manager.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/order.dart';
import 'utils/logger.dart';



class AppController extends ControllerMVC {
  factory AppController() => _this ??= AppController._();
  AppController._();
  static AppController? _this;

  final log = getLogger('app_controller');
  StreamSubscription<bool>? internetConnectivityListener;

  // late Color primaryColor;

  Timer? syncTimer;
  listenInternetConnectivity() {
    internetConnectivityListener =
        InternetConnectivity().onStatusChange.listen((status) {
      log.d('received network change, status: $status');
      status
          ? Globals.isNetworkAvailable = true
          : Globals.isNetworkAvailable = false;
    });
  }

  @override
  Future<bool> initAsync() async {
    // Simply wait for 10 seconds at startup.
    /// In production, this is where databases are opened, logins attempted, etc.
    // return Future.delayed(const Duration(seconds: 10), () {
    //   return true;
    // });
    initialiseRemoteDebug();
    Globals.sharedPreferences = await SharedPreferences.getInstance();
    listenInternetConnectivity();
    getUserInfo();

    // if (Globals().currentUser.id != null) startSynchronizeCurrentOrders();
    return true;
  }

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding initAsync() routine.
  /// Returns true if the error was properly handled.
  @override
  bool onAsyncError(FlutterErrorDetails details) {
    return false;
  }

  initialiseRemoteDebug() async {
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    remoteConfig.setDefaults(<String, dynamic>{
      'disable_app': false,
      'message': '',
      'force_version': '',
      'latest_version': '',
      'update_url': '',
      'color': '#3EB489',
      'host_url': ''
    });
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 20),
      minimumFetchInterval: Duration(hours: 1),
    ));
    bool updated = await remoteConfig.fetchAndActivate();
    log.d('updated value: $updated');

    Settings.baseUrl = remoteConfig.getString('host_url');
    // String colorCode = remoteConfig.getString('message');
    // primaryColor = Settings.getColorFromString(colorCode);
  }

  getUserInfo() {
    Globals().currentUser.id =
        Globals.sharedPreferences?.getInt(Preferences.userId);
  }


  // startSynchronizeCurrentOrders() {
  //   syncTimer?.cancel();

  //   syncTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
  //     if (Globals().currentUser.id == null) return;
  //     minibar.Controller().currentOrders = await getCurrentOrders();
  //     currentOrders.Controller().currentOrders =
  //         minibar.Controller().currentOrders;
  //     minibar.Controller().refresh();
  //   });
  // }

  getCurrentOrders() async {
    NetworkResponse response = await OrderRepository().getCurrentOrders();
    if (response.isError) {
      throw CustomException(response.errorMessage);
    } else {
      List objects = response.data;
      return objects.map((x) => Order.fromjsonData(x)).toList();
    }
  }

  checkAppStatus() async {
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    log.d('status value: ${remoteConfig.getBool('disable_app')}');
    log.d('message value: ${remoteConfig.getString('message')}');

    if (remoteConfig.getBool('disable_app') == true) {
      String message = remoteConfig.getString('message');
      if (message.isEmpty) {
        message =
            "Service under maintanence. please wait some time to continue using the app";
      }
      await NAlertDialog(
        dismissable: false,
        dialogStyle: DialogStyle(
          titleDivider: true,
        ),
        title: Text(message),
      ).show(Globals().navigatorKey.currentState!.context);
      return;
    }

    String updateUrl = Platform.isAndroid
        ? remoteConfig.getString('update_url')
        : remoteConfig.getString('ios_update_url');
    checkAppVersionAndProceed(
        Globals().navigatorKey.currentState!.context,
        remoteConfig.getString('force_version'),
        remoteConfig.getString('latest_version'),
        updateUrl);
  }

  logout() async {
    await Globals.sharedPreferences?.clear();

    FirebaseMessaging.instance.deleteToken();
    Globals().currentUser = User();
    Globals().navigatorKey.currentState?.pushNamedAndRemoveUntil(
        !Settings.isAdminApp ? Pages.login : Pages.adminLogin,
        (Route<dynamic> route) => false);
  }
}
