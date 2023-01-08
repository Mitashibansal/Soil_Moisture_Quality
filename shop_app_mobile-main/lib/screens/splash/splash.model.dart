import 'package:uia_app/repositories/auth_repository.dart';
import 'package:uia_app/utils/custom_exceptions.dart';
import 'package:uia_app/utils/http_helper.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class Model extends ModelMVC {
  factory Model([StateMVC? state]) {
    // return _this ??= Model._(state);
    return Model._(state);
  }
  Model._(StateMVC? state) : super(state);
  static Model? _this;

  getConfig() async {
    NetworkResponse response = await AuthRepository().getConfig();
    if (response.isError) {
      // throw CustomException(response.errorMessage);
    } else {
      Map<String, dynamic> data = response.data;
      if (data != null && data['message'] != null)
        throw CustomException(data['message']);
    }
    // return null;
  }
}
