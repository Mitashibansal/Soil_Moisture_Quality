import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'logger.dart';

enum LoaderStatus { loading, loaded, empty, error }

class Loader {
  static final log = getLogger('Loader');
  static Widget loader(context, {color}) {
    return SpinKitCircle(
      color: color != null ? color : Theme.of(context).primaryColor,
      size: 50.0,
    );
  }

  static Widget ringLoader(context,
      {double size = 50.0, double lineWidth = 2, color}) {
    return SpinKitRing(
      color: color != null ? color : Theme.of(context).primaryColor,
      lineWidth: lineWidth,
      size: size,
    );
  }

  static openLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return loader(context);
      },
    );
  }

  static ProgressDialog? pd;
  static startFullScreenLoader(BuildContext context, String message,
      {isDismissible = true}) async {
    pd = ProgressDialog(context,
        isDismissible: isDismissible, type: ProgressDialogType.normal);
    pd?.style(
      message: message,
    );
    await pd?.show();
  }

  static updateFullScreenLoader(String message) {
    return pd?.update(message: message);
  }

  static hideFullScreenLoader() async {
    log.d("hiding loader if any");
    if (pd == null) return;
    await pd?.hide();
  }

  static isFullScreenLoading() {
    return pd?.isShowing();
  }
}

class ProgressLoader {
  static final log = getLogger('ProgressLoader');

  static ProgressDialog? progressLoader;
  static startProgressLoader(BuildContext context, String message,
      {isDismissible = true}) async {
    progressLoader = ProgressDialog(context,
        isDismissible: isDismissible, type: ProgressDialogType.download);
    await progressLoader?.show();
  }

  static updateProgressLoader({String? message, double? progress}) {
    progressLoader?.update(
      progress: progress?.roundToDouble(),
      message: message,
      progressWidget: Container(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            value: progress! / 100,
          )),
      maxProgress: 100,
      // progressTextStyle: TextStyle(
      //     color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      // messageTextStyle: TextStyle(
      //     color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600),
    );
  }

  static hideProgressLoader() async {
    log.d("hiding loader if any");
    if (progressLoader == null) return;
    await progressLoader?.hide();
  }
}
