import 'package:flutter/material.dart';
import 'package:uia_app/utils/logger.dart';
import 'package:uia_app/utils/pages.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'webview.model.dart';

class Controller extends ControllerMVC {
  factory Controller([StateMVC? state]) {
    // return _this ??= Controller._(state);
    return Controller._(state);
  }
  Controller._(StateMVC? state)
      : _model = Model(),
        super(state);
  static Controller? _this;

  final Model _model;

  /// Note, the count comes from a separate class, _Model.
  // int get count => _model.counter;
  // set count(value) => _model.count = value;

  final log = getLogger('template');

  WebViewArguments? get arguments => _model.arguments;

  set arguments(arguments) {
    _model.arguments = arguments;
  }

  void init() {}
}
