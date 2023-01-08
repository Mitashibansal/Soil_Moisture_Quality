import 'package:uia_app/utils/settings.dart';

isPhoneNumberValid(text) {
  RegExp regex = RegExp(Settings.phoneNumberValidatorLogin);
  if (regex.hasMatch(text)) {
    return true;
  } else {
    return false;
  }
}
