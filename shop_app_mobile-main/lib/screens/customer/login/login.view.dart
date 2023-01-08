import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uia_app/app_theme.dart';
import 'package:uia_app/utils/loader.dart';
import 'package:uia_app/utils/settings.dart';
import 'package:uia_app/utils/strings.dart';
import 'package:uia_app/utils/validators.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'login.controller.dart';
import 'package:uia_app/utils/scale.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, this.title = 'Login'}) : super(key: key);

  // Fields in a StatefulWidget should always be "final".
  final String title;

  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends StateMVC<LoginScreen> {
  _LoginScreenState() : super(Controller()) {
    con = controller as Controller;
  }
  late Controller con;
  late AppStateMVC appState;

  String selectedLocaleString=Settings.localeStrings[0];

  @override
  void initState() {
    super.initState();
    appState = rootState!;

    /// You're able to retrieve the Controller(s) from other State objects.
    // var con = appState.controller;
    // // con = appState.controllerByType<AppController>();
    // con = appState.controllerById(con?.keyId);
    con.init();

  }

  Widget customSizeBox({required double height}) {
    return SizedBox(
      height: height,
    );
  }

  Widget loginButton(BuildContext context) {
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
            con.onLoginPressed();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Text(
                  'login.verify_button'.tr(),
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

      // return Container(
      //   // padding: EdgeInsetsDirectional.only(bottom: 10),
      //   child: SizedBox(
      //     height: 45.0,
      //     width: double.infinity,
      //     child: ElevatedButton(
      //       style: ElevatedButton.styleFrom(
      //         primary: Theme.of(context).primaryColor,
      //       ),
      //       child: Text(
      //         Strings.nextButton,
      //         style: TextStyle(
      //             color: Theme.of(context).primaryTextTheme.button?.color,
      //             fontWeight: FontWeight.normal,
      //             fontSize: FontSizes.buttonText1),
      //       ),
      //       // shape: RoundedRectangleBorder(
      //       //     borderRadius: BorderRadius.circular(30.0)),
      //       onPressed: () {
      //         // setState(() async {
      //         //   // data.changeLocale(locale: Locale("ta", "IN"));

      //         //   data.changeLocale(locale: Locale("en", "US"));
      //         //   // print(Localizations.of(context, type));
      //         // });
      //         con.onLoginPressed();
      //       },
      //     ),
      //   ),
      // );
    }
  }

  Widget loginUi() {
    return Form(
      key: con.formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          children: [
            customSizeBox(height: 40.sh),
            Align(alignment: Alignment.centerRight,
              child: DropdownButton(
                 
                // Initial Value
                value: selectedLocaleString,
                 
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),   
                 
                // Array list of items
                items: Settings.localeStrings.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) async {
                  setState(() {
                    selectedLocaleString = newValue!;
                  });
                  int index = Settings.localeStrings.indexWhere((element) => element==selectedLocaleString);
                  Locale selectedLocale = Settings.locales[index];
                  await context.setLocale(selectedLocale);
                },
              ),
            ),
            customSizeBox(height: 15.sh),
            Container(
              // height: 200.sh,
              // width: 200.sw,
              child: Image.asset("assets/logo.png"),
            ),
            // customSizeBox(height: 10.0),
            Center(
                child: Text(
              "login.welcome".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25.sf, fontWeight: FontWeight.w600),
            )),
            customSizeBox(height: 20.sh),
            Center(
                child: Text(
              "login.enter_number".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.sf, fontWeight: FontWeight.normal),
            )),
            customSizeBox(height: 15.sh),
            Row(
              children: <Widget>[
                // Center(child: Text("Enter your phone number")),
                // Flexible(
                //   child: new Container(),
                //   flex: 1,
                // ),
                Flexible(
                  flex: 2,
                  child: TextFormField(
                    decoration: const InputDecoration(border: InputBorder.none),
                    textAlign: TextAlign.center,
                    autofocus: false,
                    enabled: false,
                    initialValue: Settings.countryCode,
                    style:  TextStyle(fontSize: 20.sf, color: Colors.black),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                Flexible(
                  flex: 9,
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    maxLength: 10,
                    decoration:  InputDecoration(
                        counterText: "", errorStyle: TextStyle(fontSize: 12.sf)),
                    // inputFormatters: <TextInputFormatter>[
                    //   WhitelistingTextInputFormatter.digitsOnly,
                    // ],
                    autofocus: false,
                    enabled: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    style:  TextStyle(fontSize: 20.sf, color: Colors.black),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return Strings.mobileNumberMissing;
                      } else if (!isPhoneNumberValid(value)) {
                        return Strings.mobileNumberMissing;
                      }
                      return null;
                    },
                    onSaved: (number) {
                      con.user.phone = number;
                    },
                    onFieldSubmitted: (value) {
                      con.onLoginPressed();
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
            customSizeBox(height: 20.0),
            Column(
              children: <Widget>[
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
                loginButton(context),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.loginPrimaryColor,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: loginUi(),
              ),
            ),
            // Column(
            //   children: <Widget>[
            //     Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 5.sw),
            //       child: Center(
            //         child: Text(
            //           con.errorMessage ?? "",
            //           textAlign: TextAlign.center,
            //           style: TextStyle(color: Theme.of(context).errorColor),
            //         ),
            //       ),
            //     ),
            //     customSizeBox(height: 2.0),
            //     loginButton(context),
            //   ],
            // )
          ],
        ),
      );
}
