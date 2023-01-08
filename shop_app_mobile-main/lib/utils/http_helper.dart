import 'dart:convert';

import 'package:uia_app/app.controller.dart';

import 'globals.dart';
import 'logger.dart';
import 'preferences.dart';
import 'settings.dart';
import 'strings.dart';
import 'package:http/http.dart' as http;

enum HttpMethods { get, post, put, delete, authentication }

enum ResponseStatus { success, error }

class NetworkResponse {
  var data;
  int? statusCode;
  String? error;
  ResponseStatus? status;
  NetworkResponse({this.data, this.statusCode, this.status, this.error});

  get isError => status != ResponseStatus.success || statusCode != 200;
  get errorMessage => status == ResponseStatus.error
      ? error
      : (data['message'] ?? data['message'] ?? data['message']);
}

class HttpHelper {
  factory HttpHelper() => _this ??= HttpHelper._();
  HttpHelper._();
  static HttpHelper? _this;

  final log = getLogger('Http helper');

  String? authToken;

  String? getToken() {
    authToken = Globals.sharedPreferences?.getString(Preferences.authToken);
    if (authToken != null) {
      log.v("token $authToken");
      return authToken;
    } else {
      return null;
    }
  }

  request(HttpMethods requestType,
      {String? baseUrl,
      endPoint = "",
      data,
      authenticationRequired = false,
      tryCount = 0,
      linkedintoken = ""}) async {
    baseUrl = baseUrl ?? Settings.baseUrl;
    if (baseUrl == null || baseUrl.isEmpty) {
      return NetworkResponse(
        status: ResponseStatus.error,
        error: "Please connect to the Internet. Code: 5002",
      );
    }
    var endPointURL = Uri.parse(baseUrl + endPoint);
    log.d("$requestType url: $endPointURL request data: $data");
    log.d('network availability ${Globals.isNetworkAvailable}');
    if (!Globals.isNetworkAvailable) {
      return NetworkResponse(
        status: ResponseStatus.error,
        error: Strings.internetNotAvailable,
      );
    }

    var token = getToken();
    log.d("token is $token");
    if (token == null && authenticationRequired) {
      return NetworkResponse(
        status: ResponseStatus.error,
        error: Strings.errorMessage,
      );
    }

    try {
      http.Response response;
      Map<String, String> header = {"Content-Type": "application/json"};
      if (authenticationRequired) header["Authorization"] = "Bearer $token";

      response = await _httpInvoke(requestType, endPointURL, header, data);

      log.d(
          "response: ${response.statusCode} and response body:  ${response.body}");

      // if (response.statusCode == 422 && authenticationRequired) {
      //   AppController().logout();
      // }

      var extractdata = json.decode(response.body);
      return NetworkResponse(
        data: extractdata,
        statusCode: response.statusCode,
        status: ResponseStatus.success,
        error: null,
      );
    } catch (e) {
      return NetworkResponse(
        status: ResponseStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<http.Response> _httpInvoke(HttpMethods requestType, Uri endPointURL,
      Map<String, String> header, data) async {
    switch (requestType) {
      case HttpMethods.get:
        return await http
            .get(endPointURL, headers: header)
            .timeout(Settings.httpRequestTimeout);

      case HttpMethods.post:
        return await http
            .post(endPointURL, body: data, headers: header)
            .timeout(Settings.httpRequestTimeout);

      case HttpMethods.put:
        return await http
            .put(endPointURL, body: data, headers: header)
            .timeout(Settings.httpRequestTimeout);

      case HttpMethods.delete:
        return await http
            .delete(endPointURL, headers: header)
            .timeout(Settings.httpRequestTimeout);

      default:
        throw Exception();
    }
  }
}
