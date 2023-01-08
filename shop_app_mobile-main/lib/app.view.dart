import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uia_app/screens/splash/splash.view.dart';
import 'package:uia_app/utils/router.dart';
import 'package:uia_app/utils/scale.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:ndialog/ndialog.dart';

import 'app.controller.dart';
import 'app_theme.dart';
import 'utils/globals.dart';



import 'package:easy_localization/easy_localization.dart';

class MyApp extends AppStatefulWidgetMVC {
  const MyApp({Key? key}) : super(key: key);

  /// This is the App's State object
  @override
  AppStateMVC createState() => _MyAppState();
}

///
class _MyAppState extends AppStateMVC<MyApp> {
  factory _MyAppState() => _this ??= _MyAppState._();

  _MyAppState._()
      : super(
          controller: AppController(),
          controllers: [
            // Controller(),
            // AnotherController(),
            // YetAnotherController(),
          ],

          /// Demonstrate passing an 'object' down the Widget tree much like
          /// in the Scoped Model
          object: 'Hello!',
        );
  static _MyAppState? _this;

  final CustomRouter _customRouter = CustomRouter();

  Future<bool> _onBackPressed() async {
    bool needClose = false;
    needClose = await NAlertDialog(
      dialogStyle: DialogStyle(
        titleDivider: true,
      ),
      title: Text('Are you sure?'),
      content: Text('Do you want to exit'),
      actions: [
        ElevatedButton(
            child: Text("No"),
            onPressed: () {
              Navigator.of(context).pop(false);
            }),
        ElevatedButton(
            child: Text("Yes"),
            onPressed: () {
              Navigator.of(context).pop(true);
            }),
      ],
    ).show(context);
    print('need close: $needClose');
    return needClose;
  }

  /// Optionally you can is the framework's buildApp() function
  /// instead of its build() function and allows for the InheritWidget feature
  @override
  Widget buildChild(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: themeData(AppColors.primaryColor),
      home: FutureBuilder<bool>(
        future: initAsync(),
        builder: (context, snapshot) {
          Scale.setup(context, const Size(364, 812));
          if (snapshot.hasData && snapshot.data!) {
            // return TabBarScreen();
            return SplashScreen(key: UniqueKey());
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          // By default, show a loading spinner.
          return const Center(child: CircularProgressIndicator());
        },
      ),
      navigatorKey: Globals().navigatorKey,
      onGenerateRoute: _customRouter.getRoute,
    );
  }
}
