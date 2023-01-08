import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uia_app/models/user.dart';
import 'package:uia_app/repositories/auth_repository.dart';
import 'package:uia_app/utils/custom_exceptions.dart';
import 'package:uia_app/utils/http_helper.dart';
import 'package:uia_app/utils/loader.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class Model extends ModelMVC {
  factory Model([StateMVC? state]) {
    // return _this ??= Model._(state);
    return Model._(state);
  }
  Model._(StateMVC? state) : super(state);
  static Model? _this;

  bool isOtpResendingInProgress = false;
  LoaderStatus isLoading = LoaderStatus.loaded;
  LoaderStatus isReferrerLoading = LoaderStatus.empty;
  String? referrerErrorMessage;
  String? errorMessage;
  String? otp;
  bool resendEnabled = false;
  String otpWaitTimeLabel = "";
  // SharedPreferences mySharedPreferences;
  User user = User();
  TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState>? formKey = GlobalKey<FormState>();
  // AuthRepository authRepo = AuthRepository();
  SmsAutoFill? autoFill;
  Timer? timer;
  StreamSubscription<String>? smsListener;

  firebase.FirebaseAuth auth = firebase.FirebaseAuth.instance;
  String? firebaseVerificationId;

  User? referrer;

  verifyUser(User user) async {
    NetworkResponse response =
        await AuthRepository().initiateUserVerification(user);
    if (response.isError) {
      throw CustomException(response.errorMessage);
    } else {
      return response.data;
    }
  }

  resendOtp(User user) async {
    NetworkResponse response = await AuthRepository().sendOtp(user, true);
    if (response.isError) {
      throw CustomException(response.errorMessage);
    } else {
      return response.data;
    }
    // return null;
  }

  getProfileByReferralCode(String phone) async {
    NetworkResponse response =
        await AuthRepository().getProfileByReferralCode(phone);
    if (response.isError) {
      throw CustomException(response.errorMessage);
    } else {
      Map<String, dynamic> object = response.data;
      return User.fromMap(object);
    }
    // return null;
  }

  firebaseAuthSendOtp() async {
    try {
      await firebase.FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${user.phone}',
        verificationCompleted: (firebase.PhoneAuthCredential credential) {},
        verificationFailed: (firebase.FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          print('sent');
          print(verificationId);
          firebaseVerificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on firebase.FirebaseException {
      throw CustomException("Some error occured. Please try later");
    } catch (e) {
      throw CustomException(e.toString());
    }
  }

  Future<bool> firebaseVerifyOtp(String code) async {
    firebase.PhoneAuthCredential credential =
        firebase.PhoneAuthProvider.credential(
            verificationId: firebaseVerificationId!, smsCode: code);
    try {
      await firebase.FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((firebase.UserCredential authRes) {
        print("user done");
        return true;
      });
    } on firebase.FirebaseAuthException {
      throw CustomException("Otp is incorrect");
    } catch (e) {
      throw CustomException(e.toString());
    }
    return false;
  }
}
