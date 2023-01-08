import 'package:flutter/src/widgets/framework.dart';

class Strings {
  Strings._();

  //General
  static const String appName = "Lifty Cash";

  static const String errorMessage =
      "Some error has occurred. Please try again later";
  static const String internetNotAvailable =
      "Please check your internet connection";

  //login screen
  static String nextButton = "SEND OTP";
  static String welcome = "Welcome";
  static String enterYourPhoneNumber = "Enter your phone number";
  static String mobileNumberMissing = "Please enter the Mobile Number";

  //Otp screen
  static const String otpSentMessage = "Otp has been sent successfully.";
  static const String resendOtp = "Resend SMS";
  static const String verifyOtpLabel = "VERIFY";
  static const String resendButton = " Resend";
  static const String verifyOtpTitle = "Verifying your number";
  static const String verifyOtpMessage =
      "Please type the verification code sent to ";
  static const String otpResendLabel = "Didn't get the otp?";
  static String otpAvailableIn(String remainingTime) {
    return " in $remainingTime";
  }
}
