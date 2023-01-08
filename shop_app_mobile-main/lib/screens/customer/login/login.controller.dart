import 'package:flutter/material.dart';
import 'package:uia_app/utils/globals.dart';
import 'package:uia_app/utils/loader.dart';
import 'package:uia_app/utils/logger.dart';
import 'package:uia_app/utils/pages.dart';
import 'package:uia_app/utils/preferences.dart';
import 'package:uia_app/utils/settings.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'login.model.dart';

class Controller extends ControllerMVC {
  final log = getLogger('login_screen');
  factory Controller([StateMVC? state]) => _this ??= Controller._(state);
  Controller._(StateMVC? state)
      : _model = Model(),
        super(state);
  static Controller? _this;

  final Model _model;

  get isLoading => _model.isLoading;

  get formKey => _model.formKey;

  get errorMessage => _model.errorMessage;
  get user => _model.user;

  void init() {
    log.v("init");
  }

  Future onLoginPressed() async {
    // Navigator.pushNamed(_this.stateMVC.context, Pages.homeScreen);
    // return;
    setState(() {
      _model.errorMessage = null;
    });

    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      login();
    }
  }

  Future login() async {
    setState(() {
      _model.isLoading = LoaderStatus.loading;
    });

    try {
      // Map authenticationResponse = await _model.login(_model.user);
      // print('gfh');
      // log.d("response: $authenticationResponse", "login");
      // print(authenticationResponse);
      // _model.user.isNewUser = authenticationResponse['is_new_user'];
      Globals.sharedPreferences
          ?.setString(Preferences.phone, _model.user.phone.toString());

      setState(() {
        _model.isLoading = LoaderStatus.loaded;
      });

      Navigator.of(state!.context).pushNamedAndRemoveUntil(
          Pages.otpVerification, (Route<dynamic> route) => false,
          arguments: _model.user); //remove all the screens below

      // Navigator.of(state!.context).pushNamed(Pages.otpVerification,
      //     arguments: _model.user); //remove all the screens below

    } catch (e) {
      setState(() {
        _model.isLoading = LoaderStatus.loaded;
        _model.errorMessage = e.toString();
      });
    }
  }
}
