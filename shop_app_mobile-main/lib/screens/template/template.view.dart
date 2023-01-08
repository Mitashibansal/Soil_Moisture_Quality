// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:uia_app/utils/scale.dart';

import 'template.controller.dart';

class TemplateScreen extends StatefulWidget {
  const TemplateScreen({Key? key, this.title = 'Flutter Demo'})
      : super(key: key);

  // Fields in a StatefulWidget should always be "final".
  final String title;

  @override
  State createState() => _TemplateScreenState();
}

class _TemplateScreenState extends StateMVC<TemplateScreen> {
  _TemplateScreenState() : super(Controller()) {
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
    con.init();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Title"),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.sw, vertical: 15.sh),
            child: Center(
              child: Text(
                'Home screen to be done',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          key: const Key('+'),
          onPressed: () => con.init(),
          child: const Icon(Icons.add),
        ),
      );
}
