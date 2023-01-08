// ignore_for_file: await_only_futures

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uia_app/models/user.dart';
import 'package:uia_app/utils/flushbar.dart';
import 'package:uia_app/utils/globals.dart';
import 'package:uia_app/utils/loader.dart';
import 'package:uia_app/utils/logger.dart';
import 'package:uia_app/utils/pages.dart';
import 'package:uia_app/utils/preferences.dart';
import 'package:uia_app/utils/settings.dart';
import 'package:uia_app/utils/strings.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'otp_verification.model.dart';

class Controller extends ControllerMVC {
  final log = getLogger('login_screen');
  factory Controller([StateMVC? state]) {
    // return _this ??= Controller._(state);
    return Controller._(state);
  }
  Controller._(StateMVC? state)
      : _model = Model(),
        super(state);
  static Controller? _this;

  final Model _model;

  get isOtpResendingInProgress => _model.isOtpResendingInProgress;
  get isLoading => _model.isLoading;
  get errorMessage => _model.errorMessage;
  get isReferrerLoading => _model.isReferrerLoading;
  get referrerErrorMessage => _model.referrerErrorMessage;
  get otpController => _model.otpController;
  get remainingTimeLabel => _model.otpWaitTimeLabel;
  get resendEnabled => _model.resendEnabled;
  get otp => _model.otp;

  get formKey => _model.formKey;

  User get user => _model.user;
  User? get referrer => _model.referrer;

  set user(user) {
    _model.user = user;
  }

  set otp(otp) {
    _model.otp = otp;
  }

  set remainingTimeLabel(value) => _model.otpWaitTimeLabel = value;

  @override
  void dispose() {
    //runs second
    _model.timer?.cancel();
    try {
      // _model.autoFill?.unregisterListener();
      SmsAutoFill().unregisterListener();
    } catch (e) {}
    _model.smsListener?.cancel();
    _this = null;
    log.d("disposing otp screen");

    super.dispose();
  }

  Future init() async {
    _model.autoFill = SmsAutoFill();
    openSmsListener();

    startTimer();
    _model.firebaseAuthSendOtp();

    // await Future.delayed(Duration(milliseconds: 300), () {
    //   setState(() {
    //     phone = Globals.sharedPreferences?.getString(Preferences.phone);
    //   });
    //   _model.user?.phone = phone;
    // });
    // otpEntered(otp.toString());
  }

  openSmsListener() async {
    _model.smsListener?.cancel();
    try {
      _model.autoFill?.unregisterListener();
    } catch (e) {}
    var sign = await SmsAutoFill().getAppSignature;
    print(sign);
    await _model.autoFill?.listenForCode;
    print('starting listener');
    // _model.smsListener = _model.autoFill?.code.listen((code) {
    //   print('code received');
    //   _model.otpController.text = code;
    //   otpEntered(code, true);
    // });
  }

  void startTimer() {
    int remainingTime = Settings.waitSecondsForOtpResend;
    _model.resendEnabled = false;
    setState(() {
      remainingTimeLabel = Strings.otpAvailableIn(
          "${remainingTime ~/ 60}:${remainingTime % 60}");
    });
    _model.timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      remainingTime = remainingTime - 1;
      setState(() {
        remainingTimeLabel = Strings.otpAvailableIn(
            "${remainingTime ~/ 60}:${remainingTime % 60}");
      });
      if (remainingTime <= 0) {
        timer.cancel();
        _model.resendEnabled = true;
        remainingTimeLabel = "";
      }
      log.v(_model.otpWaitTimeLabel, "otpTimer");
    });
  }

  onOtpResendPressed() async {
    setState(() {
      _model.errorMessage = "";
    });
    Loader.openLoadingDialog(state!.context);
    try {
      var resendOtpResponse = await _model.firebaseAuthSendOtp();
      Navigator.pop(state!.context);
      startTimer();
      FlushBarHelper.show(state!.context, message: Strings.otpSentMessage);
      openSmsListener();
    } catch (e) {
      setState(() {
        _model.errorMessage = e.toString();
      });
    }
  }

  otpEntered(String text, bool fromAutoFill) async {
    // Navigator.of(state!.context)
    //     .pushNamedAndRemoveUntil(Pages.home, (route) => false);
    log.d("submitting otp $text");
    if (text.isEmpty) return;
    if (fromAutoFill && user.isNewUser) return;
    log.d('fdh');
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    setState(() {
      _model.isLoading = LoaderStatus.loading;
    });

    await Future.delayed(Duration(milliseconds: 300), () {
      verifyOtp(text);
    });
  }

  verifyOtp(String otp) async {
    log.d("verifying otp");
    setState(() {
      _model.errorMessage = "";
    });
    try {
      bool result = await _model.firebaseVerifyOtp(otp);
      // Map otpVerificationResponse = await _model.verifyUser(_model.user);

      // int userId = otpVerificationResponse['user_id'];
      // String userName = otpVerificationResponse['user_name'];
      // String token = otpVerificationResponse['access_token'];

      // _model.user.id = userId;
      // _model.user.name = userName;

      // await Globals.sharedPreferences?.setInt(Preferences.userId, userId);
      // await Globals.sharedPreferences
      //     ?.setString(Preferences.userName, userName);
      // await Globals.sharedPreferences?.setString(Preferences.authToken, token);

      // Globals().currentUser = _model.user; //this becomes the current user

      setState(() {
        _model.isLoading = LoaderStatus.loaded;
      });
      Navigator.of(state!.context).pushNamedAndRemoveUntil(Pages.home,
          (Route<dynamic> route) => false); //remove all the screens below
    } catch (e) {
      setState(() {
        _model.isLoading = LoaderStatus.loaded;
        _model.errorMessage = e.toString();
      });
    }
  }

  void editNumber() {
    log.d('edit number');
    Navigator.pop(state!.context);
  }
}
