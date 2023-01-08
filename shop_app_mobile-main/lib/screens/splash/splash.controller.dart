import 'package:flutter/material.dart';
import 'package:uia_app/utils/globals.dart';
import 'package:uia_app/utils/logger.dart';
import 'package:uia_app/utils/notifications.dart';
import 'package:uia_app/utils/pages.dart';
import 'package:uia_app/utils/preferences.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:ndialog/ndialog.dart';
import 'package:uia_app/utils/settings.dart';

import 'splash.model.dart';

class Controller extends ControllerMVC {
  factory Controller([StateMVC? state]) {
    // return _this ??= Controller._(state);
    return Controller._(state);
  }
  Controller._(StateMVC? state)
      : _model = Model(),
        super(state);
  static Controller? _this;

  final Model _model;

  /// Note, the count comes from a separate class, _Model.
  // int get count => _model.counter;
  // set count(value) => _model.count = value;

  final log = getLogger('template');

  Future<void> init() async {
    String? token = Globals.sharedPreferences?.getString(Preferences.authToken);
    String targetPage;
    if (Settings.isAdminApp) {
      targetPage = token != null ? Pages.adminTabBar : Pages.adminLogin;
    } else {
      targetPage = token != null ? Pages.home : Pages.login;
    }
    // targetPage = Pages.home;

    // targetPage = Pages.login;
    // Navigator.of(state!.context).pushNamedAndRemoveUntil(targetPage,
    //     (Route<dynamic> route) => false); //remove all the screens below

    NoticationsHelper().initialise(context: state!.context);

    Future.delayed(Duration.zero, () {
      Navigator.of(state!.context).pushNamedAndRemoveUntil(targetPage,
          (Route<dynamic> route) => false); //remove all the screens below
    });
    // await AppController().checkAppStatus();
    getConfig();
  }

  getConfig() async {
    try {
      await _model.getConfig();
    } catch (e) {
      log.e(e.toString());

      await NAlertDialog(
        dismissable: false,
        dialogStyle: DialogStyle(
          titleDivider: true,
        ),
        title: Text(e.toString()),
      ).show(Globals().navigatorKey.currentState!.context);
    }
  }
}
