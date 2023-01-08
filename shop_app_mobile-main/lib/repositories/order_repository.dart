import 'dart:convert';
import 'dart:io';

// import 'package:device_info_plus/device_info_plus.dart';
import 'package:uia_app/models/service.dart';
import 'package:uia_app/models/service_filter.dart';
import 'package:uia_app/models/user.dart';
import 'package:uia_app/utils/endpoints.dart';
import 'package:uia_app/utils/http_helper.dart';
import 'package:uia_app/utils/logger.dart';

import '../models/order.dart';
import '../models/requirement.dart';

class OrderRepository {
  factory OrderRepository() => _this ??= OrderRepository._();
  OrderRepository._();
  static OrderRepository? _this;

  final log = getLogger('order_repository');

  final httpHelper = HttpHelper();

  createOrder(Requirement requirement) async {
    var data = requirement.toJsonForCreate();
    return await httpHelper.request(HttpMethods.post,
        authenticationRequired: true,
        endPoint: Endpoints.createOrder,
        data: json.encode(data));
  }

  getOrder(
    Order order,
  ) async {
    return await httpHelper.request(
      HttpMethods.get,
      authenticationRequired: true,
      endPoint: Endpoints.getOrder(order.id!),
    );
  }

  getCurrentOrders() async {
    return await httpHelper.request(
      HttpMethods.get,
      authenticationRequired: true,
      endPoint: Endpoints.getPendingOrders,
    );
  }

  updateOrderStatus(Order order) async {
    // var data = order.updateStatusJson();
    // return await httpHelper.request(HttpMethods.put,
    //     authenticationRequired: true,
    //     endPoint: Endpoints.saveOrder(order.id),
    //     data: json.encode(data));
  }

  getOrderHistory() async {
    return await httpHelper.request(
      HttpMethods.get,
      authenticationRequired: true,
      endPoint: Endpoints.getOrderHistory,
    );
  }
}
