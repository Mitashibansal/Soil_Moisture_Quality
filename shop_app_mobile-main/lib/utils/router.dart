// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';


import 'package:uia_app/screens/customer/login/login.view.dart';
import 'package:uia_app/screens/customer/otp_verification/otp_verification.view.dart';
import 'package:uia_app/screens/edit_profile/edit_profile.view.dart';
import 'package:uia_app/screens/feedback/feedback.view.dart';
import 'package:uia_app/screens/home/home.view.dart';


import 'package:uia_app/screens/splash/splash.view.dart';
import 'package:uia_app/screens/template/template.view.dart';
import 'package:uia_app/screens/webview/webview.view.dart';
import 'package:uia_app/utils/pages.dart';

import 'globals.dart';
import 'logger.dart';

class CustomRouter {
  factory CustomRouter() => _this ??= CustomRouter._();
  CustomRouter._();
  static CustomRouter? _this;

  final log = getLogger('CustomRouter');

  Route getRoute(RouteSettings settings) {
    // log.v(settings.name, "getRoute");
    // log.v(settings.arguments, "getRoute");

    Globals().currentRoute = settings.name;

    switch (settings.name) {
      case Pages.splash:
        return _buildRoute(settings, const SplashScreen());
      case Pages.login:
        return _buildRoute(settings, const LoginScreen());
      case Pages.otpVerification:
        return _buildRoute(settings, OtpVerifyScreen(user: settings.arguments));
      case Pages.home:
        return _buildRoute(settings, HomeScreen());
    
      case Pages.feedback:
        return _buildRoute(
            settings,
            FeedbackScreen(
                         ));

      default:
        return _buildRoute(settings, const TemplateScreen());
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, var builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (ctx) => builder,
    );
  }
}
