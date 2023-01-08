import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:uia_app/app_theme.dart';

class FlushBarHelper {
  static Flushbar show(context,
      {required String message,
      String? title,
      Duration duration = const Duration(seconds: 2),
      bool isDismissible = true,
      isTop = false,
      isError: false,
      textColor: Colors.white}) {
    // Color(0xFF303030)
    Color bgColor = AppColors.flushbarColorRegular;
    if (isError) {
      bgColor = const Color(0xffdd524d);
    }
    return Flushbar(
      title: title,
      message: message,
      duration: duration,
      isDismissible: isDismissible,
      backgroundColor: bgColor,
      messageColor: textColor,
      flushbarPosition: isTop ? FlushbarPosition.TOP : FlushbarPosition.BOTTOM,
    )..show(context);
  }
}
