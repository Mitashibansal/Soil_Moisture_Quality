// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:uia_app/utils/logger.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static final PermissionHelper _singleton = PermissionHelper._internal();
  bool isPermissionRequested = false;
  factory PermissionHelper() {
    return _singleton;
  }
  final log = getLogger('permission handler');
  PermissionHelper._internal();

  verifyPermission(Permission permission, BuildContext context) async {
    if (!isPermissionRequested) {
      isPermissionRequested = true;

      PermissionStatus permissionStatus = await permission.status;
      if (permissionStatus == PermissionStatus.granted) {
        isPermissionRequested = false;
        return true;
      } else if (permissionStatus == PermissionStatus.denied ||
          permissionStatus == PermissionStatus.restricted) {
        permissionStatus = await permission.request();
        isPermissionRequested = false;
        await verifyPermission(permission, context);
      } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
        // FlushBarHelper.show(context, message: Strings.enablePermission);

        await NDialog(
          dialogStyle: DialogStyle(titleDivider: true),
          title: Text("Permission required"),
          content:
              Text("Please allow permission in settings and open app again"),
          actions: <Widget>[
            TextButton(
                child: Text("OK"),
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(context);
                }),
          ],
        ).show(context);
      }
    } else {
      await verifyPermission(permission, context);
    }
  }
}
