import 'dart:io';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:uia_app/utils/loader.dart';

class Model extends ModelMVC {
  factory Model([StateMVC? state]) {
    // return _this ??= Model._(state);
    return Model._(state);
  }
  Model._(StateMVC? state) : super(state);
  static Model? _this;

  File? selectedImage;
  LoaderStatus loader =LoaderStatus.empty;

  Map? result;

  
  
}
