import 'package:uia_app/utils/date_time_helper.dart';

enum TransactionType { earn, withdraw }

class WalletTransaction {
  int? id;
  int? userId;
  int? childId;
  String? childName;
  int? friendId;
  String? friendName;
  TransactionType? type;
  double? amount;
  DateTime? createdTime;
  DateTime? modifiedTime;

  WalletTransaction(
      {this.id,
      this.userId,
      this.childId,
      this.childName,
      this.friendId,
      this.friendName,
      this.type,
      this.amount,
      this.createdTime,
      this.modifiedTime});

  String? get buyerName => childName ?? "$childName's friend ";

  WalletTransaction.fromJson(Map<String, dynamic> json) {
    if (json['type'] == "EARN") {
      type = TransactionType.earn;
    } else if (json['type'] == "WITHDRAW") {
      type = TransactionType.withdraw;
    }

    id = json['id'];
    userId = json['user_id'];
    childId = json['child_id'];
    childName = json['child_name'];
    friendId = json['friend_id'];
    friendName = json['friend_name'];

    amount = json['amount'];
    createdTime = DateTimeHelper.parseAsUtc(json['created_time']);
    modifiedTime = DateTimeHelper.parseAsUtc(json['modified_time']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['child_id'] = this.childId;
    data['child_name'] = this.childName;
    data['friend_id'] = this.friendId;
    data['friend_name'] = this.friendName;
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['created_time'] = this.createdTime;
    data['modified_time'] = this.modifiedTime;
    return data;
  }
}
