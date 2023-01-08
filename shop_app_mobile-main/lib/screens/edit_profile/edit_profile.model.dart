import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uia_app/models/user.dart';
import 'package:uia_app/repositories/auth_repository.dart';
import 'package:uia_app/repositories/service_repository.dart';
import 'package:uia_app/utils/custom_exceptions.dart';
import 'package:uia_app/utils/http_helper.dart';
import 'package:uia_app/utils/loader.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class Model extends ModelMVC {
  factory Model([StateMVC? state]) {
    // return _this ??= Model._(state);
    return Model._(state);
  }
  Model._(StateMVC? state) : super(state);
  static Model? _this;

  String? errorMessage;
  LoaderStatus loadingStatus = LoaderStatus.loading;
  User? user;
  User? updatedUser = User();
  final GlobalKey<FormState>? formKey = GlobalKey<FormState>();
  File? selectedImage;

  getUser() async {
    NetworkResponse response = await AuthRepository().getProfile();
    if (response.isError) {
      throw CustomException(response.errorMessage);
    } else {
      Map<String, dynamic> object = response.data;
      return User.fromMap(object);
    }
    // return null;
  }

  saveProfile() async {
    NetworkResponse response = await AuthRepository().saveProfile(updatedUser);
    if (response.isError) {
      throw CustomException(response.errorMessage);
    } else {
      var object = response.data;
      return true;
    }
  }
}
