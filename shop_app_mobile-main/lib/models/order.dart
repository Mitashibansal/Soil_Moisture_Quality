import 'dart:convert';

import 'package:uia_app/models/location.dart';
import 'package:uia_app/models/product.dart';
import 'package:uia_app/models/service.dart';
import 'package:uia_app/models/staff.dart';
import 'package:uia_app/models/status_history.dart';
import 'package:uia_app/models/user.dart';
import 'package:uia_app/utils/date_time_helper.dart';
import 'package:uia_app/utils/globals.dart';

enum OrderStatus {
  pending,
  confirmed,
  rejected,
  userCancelled,
  readyToDeliver,
  delivered
}

class Order {
  int? id;

  User? customer;
  List<Product>? products;

  int? categoryId;

  OrderStatus? status;
  DateTime? deliveryTime;
  double? totalAmount;

  DateTime? createdTime;
  DateTime? acceptedTime;
  DateTime? rejectedTime;
  DateTime? userCancelTime;
  DateTime? readyToDeliver;
  DateTime? deliveredTime;

  Order(
      {this.id,
      this.deliveryTime,
      this.totalAmount,this.status,
      this.acceptedTime,
      this.rejectedTime,
      this.userCancelTime,
      this.readyToDeliver,
      this.deliveredTime,
      this.customer,
      this.products});

  Order.fromjsonData(Map<String, dynamic> jsonData, {forInteraction = false}) {
    id = jsonData['id'];

    deliveryTime = DateTimeHelper.parseAsUtc(jsonData['reached_time']);

    createdTime = DateTimeHelper.parseAsUtc(jsonData['created_time']);
    acceptedTime = DateTimeHelper.parseAsUtc(jsonData['accepted_time']);
    print(createdTime.toString());
    readyToDeliver = DateTimeHelper.parseAsUtc(jsonData['ready_to_move_time']);

    deliveredTime = DateTimeHelper.parseAsUtc(jsonData['completed_time']);
    rejectedTime = DateTimeHelper.parseAsUtc(jsonData['rejected_time']);
    userCancelTime = DateTimeHelper.parseAsUtc(jsonData['user_cancel_time']);

    categoryId = jsonData['category_id'];

    // if (completedTime != null) {
    //   status = OrderStatus.completed;
    // } else if (reachedTime != null) {
    //   status = OrderStatus.reached;
    // } else if (readyToMoveTime != null) {
    //   status = OrderStatus.readyToMove;
    // } else if (userCancelTime != null) {
    //   status = OrderStatus.userCancelled;
    // } else if (rejectedTime != null) {
    //   status = OrderStatus.rejected;
    // } else if (acceptedTime != null) {
    //   status = OrderStatus.accepted;
    // } else {
    //   status = OrderStatus.pending;
    // }
  }
}
