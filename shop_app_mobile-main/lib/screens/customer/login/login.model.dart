import 'package:flutter/material.dart';
import 'package:uia_app/models/user.dart';
import 'package:uia_app/repositories/auth_repository.dart';
import 'package:uia_app/utils/custom_exceptions.dart';
import 'package:uia_app/utils/http_helper.dart';
import 'package:uia_app/utils/loader.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase;

class Model extends ModelMVC {
  factory Model([StateMVC? state]) => _this ??= Model._(state);
  Model._(StateMVC? state) : super(state);
  static Model? _this;

  LoaderStatus isLoading = LoaderStatus.loaded;
  String? errorMessage;
  final GlobalKey<FormState>? formKey = GlobalKey<FormState>();

  User user = User();
  firebase.FirebaseAuth auth = firebase.FirebaseAuth.instance;

  login(User user) async {
    NetworkResponse response = await AuthRepository().sendOtp(user, false);
    if (response.isError) {
      throw CustomException(response.errorMessage);
    } else {
      return response.data;
    }
    // return null;
  }
}
