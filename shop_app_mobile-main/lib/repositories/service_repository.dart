import 'dart:convert';
import 'dart:io';

// import 'package:device_info_plus/device_info_plus.dart';
import 'package:uia_app/models/service.dart';
import 'package:uia_app/models/service_filter.dart';
import 'package:uia_app/models/user.dart';
import 'package:uia_app/utils/endpoints.dart';
import 'package:uia_app/utils/http_helper.dart';
import 'package:uia_app/utils/logger.dart';

class ServiceRepository {
  factory ServiceRepository() => _this ??= ServiceRepository._();
  ServiceRepository._();
  static ServiceRepository? _this;

  final log = getLogger('service_repository');

  final httpHelper = HttpHelper();

  addService(Service service) async {
    var data = service.toJsonForCreate();
    return await httpHelper.request(HttpMethods.post,
        authenticationRequired: true,
        endPoint: Endpoints.addService,
        data: json.encode(data));
  }

  deleteService(Service service) async {
    var data = service.toJsonForCreate();
    return await httpHelper.request(HttpMethods.delete,
        authenticationRequired: true,
        endPoint: Endpoints.deleteService(service.id!),
        data: json.encode(data));
  }

  getMyServices() async {
    return await httpHelper.request(
      HttpMethods.get,
      authenticationRequired: true,
      endPoint: Endpoints.myServices,
    );
  }

  getNearbyServices(ServiceFilter? serviceFilter) async {
    var data = serviceFilter?.toJson();
    return await httpHelper.request(HttpMethods.post,
        authenticationRequired: true,
        endPoint: Endpoints.nearbyServices,
        data: json.encode(data));
  }

  getHomeContent() async {
    return await httpHelper.request(
      HttpMethods.get,
      authenticationRequired: true,
      endPoint: Endpoints.homeContent,
    );
  }
}
