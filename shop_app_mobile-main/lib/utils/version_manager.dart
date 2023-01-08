import 'package:flutter/material.dart';
import 'package:uia_app/utils/logger.dart';
import 'package:ndialog/ndialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

final log = getLogger('version_manager');

checkAppVersionAndProceed(BuildContext context, String forceVersion,
    String latestVersion, String updateUrl) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  log.v('current app version $version');

  if (updateUrl.isEmpty) return;
  if (isVersionHigher(forceVersion, version)) {
    await NAlertDialog(
      dismissable: false,
      dialogStyle: DialogStyle(
        titleDivider: true,
      ),
      title: const Text("Please update the app to the latest version"),
      actions: [
        ElevatedButton(
            child: Text("Okay"),
            onPressed: () async {
              launch(updateUrl);
            }),
      ],
    ).show(context);
    return;
  }
  if (isVersionHigher(latestVersion, version)) {
    //a latest version is available
    await NAlertDialog(
      dialogStyle: DialogStyle(
        titleDivider: true,
      ),
      title: const Text("New Version Available!"),
      actions: [
        ElevatedButton(
            child: Text("Later"),
            onPressed: () async {
              Navigator.of(context).pop();
            }),
        ElevatedButton(
            child: Text("Update Now"),
            onPressed: () async {
              launch(updateUrl);
            }),
      ],
    ).show(context);
    return;
  }
}

isVersionHigher(String version, String currentVersion) {
  List versionDigits = version.split(".");
  List currentVersionDigits = currentVersion.split(".");
  for (int i = 0; i < 3; i++) {
    log.v("${versionDigits[i]} ${currentVersionDigits[i]}");
    var versionDigit = int.parse(versionDigits[i]);
    var currentVersionDigit = int.parse(currentVersionDigits[i]);
    if (versionDigit > currentVersionDigit) {
      log.d("version is higher");
      return true;
    } else if (versionDigit < currentVersionDigit) {
      return false;
    }
  }
  log.d("version is not higher");
  return false;
}
