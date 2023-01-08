import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uia_app/app_theme.dart';
import 'package:uia_app/models/user.dart';
import 'package:uia_app/utils/globals.dart';
import 'package:uia_app/utils/loader.dart';
import 'package:uia_app/utils/scale.dart';
import 'package:uia_app/utils/settings.dart';
import 'package:uia_app/utils/strings.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'otp_verification.controller.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({Key? key, required this.user}) : super(key: key);

  // Fields in a StatefulWidget should always be "final".
  final Object? user;

  @override
  State createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends StateMVC<OtpVerifyScreen> {
  _OtpVerifyScreenState() : super(Controller()) {
    con = controller as Controller;
  }
  late Controller con;
  late AppStateMVC appState;

  @override
  void initState() {
    super.initState();
    appState = rootState!;

    /// You're able to retrieve the Controller(s) from other State objects.
    // var con = appState.controller;
    // // con = appState.controllerByType<AppController>();
    // con = appState.controllerById(con?.keyId);
    con.user = widget.user;
    con.init();
  }

  Widget customSizeBox({required double height}) {
    return SizedBox(
      height: height,
    );
  }

  Widget resendButtonBackup(BuildContext context) {
    if (con.isOtpResendingInProgress) {
      return const CircularProgressIndicator(strokeWidth: 2);
    } else {
      return Container(
        child: SizedBox(
          height: 45.sh,
          width: double.infinity,
          child: TextButton(
            style: TextButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
            child: Text(
              Strings.resendOtp + (con.remainingTimeLabel ?? ""),
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 13.sf),
            ),
            onPressed: con.resendEnabled
                ? () {
                    con.onOtpResendPressed();
                  }
                : null,
          ),
        ),
      );
    }
  }

  Widget verifyOtpButton(BuildContext context) {
    if (con.isLoading == LoaderStatus.loading) {
      return const CircularProgressIndicator(strokeWidth: 2);
    } else {
      return Container(
        height: 58.sh,
        width: 258.sw,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8 + 32),
          color: AppColors.loginButtonColor,
        ),
        child: InkWell(
          key: ValueKey('Sign Up button'),
          onTap: () {
            con.otpEntered(con.otp, false);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 16.sw, right: 16.sw),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Text(
                  'otp_screen.verify_button'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sf,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(Icons.arrow_forward_rounded, color: Colors.white),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget otpResendButton(BuildContext context) {
    return InkWell(
      child: Text("otp_screen.resend_button".tr() + con.remainingTimeLabel,
          style: TextStyle(color: Theme.of(context).primaryColor)),
      onTap: con.resendEnabled
          ? () {
              setState(() {
                con.onOtpResendPressed();
              });
            }
          : null,
    );
  }

  Widget otpUI() {
    return Form(
        key: con.formKey,
        child: Container(
          // height: MediaQuery.of(context).size.height,
          padding:  EdgeInsets.symmetric(horizontal: 40.sw),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              customSizeBox(height: 20.0),
              Container(
                // height: 150.0,
                child: Image.asset("assets/verify-otp.png"),
              ),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style:  TextStyle(
                      fontSize: 16.sf,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                       TextSpan(
                        text: "otp_screen.verify_otp".tr(),
                      ),
                      TextSpan(
                        text: con.user.phone ?? "",
                        style: const TextStyle(
                            color: AppColors.loginButtonColor,
                            fontWeight: FontWeight.normal,
                            height: 1.5),
                      ),
                      // TextSpan(
                      //   text: " Wrong number?",
                      //   recognizer: TapGestureRecognizer()
                      //     ..onTap = () {
                      //       con.editNumber();
                      //     },
                      //   style: TextStyle(
                      //       color: Theme.of(context).primaryColor, height: 1.5),
                      // ),
                    ],
                  ),
                ),
              ),
              // customSizeBox(height: 1.0),
              PinFieldAutoFill(
                decoration: UnderlineDecoration(
                  textStyle: TextStyle(fontSize: 20.sf, color: Colors.black),
                  colorBuilder:
                      FixedColorBuilder(Colors.black.withOpacity(0.3)),
                ),
                currentCode: con.otp ?? "",
                onCodeSubmitted: (code) {},
                onCodeChanged: (code) {
                  print('changed');
                  print(code);
                  setState(() {
                    con.otp = code;
                  });

                  if (code!.length == 6 && !con.user.isNewUser) {
                    con.otpEntered(con.otp, false);
                    FocusScope.of(context).requestFocus(FocusNode());
                  }
                },
              ),
              customSizeBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   Text(
                    "otp_screen.otp_resend".tr(),
                    style: TextStyle(color: AppColors.loginButtonColor),
                  ),
                  otpResendButton(context),
                ],
              ),
              if (con.user.isNewUser)
                TextFormField(
                  textAlign: TextAlign.start,
                  maxLength: 25,
                  decoration:  InputDecoration(
                      hintText: "Name",
                      hintStyle: TextStyle(fontSize: 16.sf),
                      counterText: "",
                      errorStyle: TextStyle(fontSize: 12.sf)),
                  // inputFormatters: <TextInputFormatter>[
                  //   WhitelistingTextInputFormatter.digitsOnly,
                  // ],
                  autofocus: false,
                  enabled: true,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  style:  TextStyle(fontSize: 16.sf, color: Colors.black),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your name";
                      // } else if (!isPhoneNumberValid(value)) {
                      return Strings.mobileNumberMissing;
                    }
                    return null;
                  },
                  onSaved: (name) {
                    con.user.name = name;
                  },
                ),
              SizedBox(height: 5.sh),
              customSizeBox(height: 20.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.sw),
                child: Center(
                  child: Text(
                    con.errorMessage ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).errorColor),
                  ),
                ),
              ),
              customSizeBox(height: 5.0),
              verifyOtpButton(context),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.loginPrimaryColor,
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: otpUI(),
                ),
              ),
              // Column(
              //   children: <Widget>[
              //     if (con.errorMessage != null)
              //       Center(
              //         child: Padding(
              //           padding: const EdgeInsets.only(top: 2, bottom: 2),
              //           child: Text(
              //             con.errorMessage ?? "",
              //             textAlign: TextAlign.center,
              //             style: TextStyle(color: Theme.of(context).errorColor),
              //           ),
              //         ),
              //       ),
              // customSizeBox(height: 2.0),

              //   ],
              // ),
            ],
          )),
      onWillPop: () => Future.value(false));
}
