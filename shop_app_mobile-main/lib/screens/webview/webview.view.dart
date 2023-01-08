// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uia_app/screens/webview/webview.model.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:uia_app/utils/scale.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'webview.controller.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key, required this.arguments}) : super(key: key);

  // Fields in a StatefulWidget should always be "final".
  final Object? arguments;

  @override
  State createState() => _WebViewScreenState();
}

class _WebViewScreenState extends StateMVC<WebViewScreen> {
  _WebViewScreenState() : super(Controller()) {
    con = controller as Controller;
  }
  late Controller con;
  late AppStateMVC appState;

  @override
  void initState() {
    super.initState();
    appState = rootState!;

    // var con = appState.controller;
    // // con = appState.controllerByType<AppController>();
    // con = appState.controllerById(con?.keyId);
    con.arguments = widget.arguments;
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    con.init();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(con.arguments?.title ?? ""),
        ),
        body: SafeArea(
          child: WebView(
            initialUrl: con.arguments?.url,
          ),
        ),
      );
}
