import 'package:uia_app/utils/date_time_helper.dart';

enum TransactionType { buy, consume, transfer }

class CreditHistory {
  int? id;
  int? userId;
  int? receiverId;
  int? orderId;
  int? quantity;
  TransactionType? type;
  String? receiverName;
  String? senderName;
  DateTime? createdTime;

  CreditHistory(
      {this.id,
      this.userId,
      this.receiverId,
      this.orderId,
      this.quantity,
      this.type,
      this.receiverName,
      this.senderName});

  CreditHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    receiverId = json['receiver_id'];
    orderId = json['order_id'];
    quantity = json['quantity'];
    type = TransactionType.values[json['type']];
    receiverName = json['receiver_name'];
    senderName = json['sender_name'];
    createdTime = DateTimeHelper.parseAsUtc(json['created_time']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['receiver_id'] = this.receiverId;
    data['order_id'] = this.orderId;
    data['quantity'] = this.quantity;
    data['type'] = this.type;
    data['receiver_name'] = this.receiverName;
    data['sender_name'] = this.senderName;
    return data;
  }
}
