import 'package:mvc_pattern/mvc_pattern.dart';

class Model extends ModelMVC {
  factory Model([StateMVC? state]) {
    // return _this ??= Model._(state);
    return Model._(state);
  }
  Model._(StateMVC? state) : super(state);
  static Model? _this;
}
