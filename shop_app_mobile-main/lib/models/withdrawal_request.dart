import 'package:uia_app/utils/date_time_helper.dart';

enum Status { pending, success, failed }

class WithdrawalRequest {
  int? id;
  int? userId;
  String? orderId;
  String? type;
  Status? transactionStatus;
  String? transactionId;
  String? bankTransactionId;
  double? amount;
  DateTime? createdTime;
  DateTime? modifiedTime;

  WithdrawalRequest(
      {this.id,
      this.userId,
      this.orderId,
      this.type,
      this.transactionStatus,
      this.transactionId,
      this.bankTransactionId,
      this.amount,
      this.createdTime,
      this.modifiedTime});

  WithdrawalRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    type = json['type'];
    transactionStatus = json['transaction_status'] != null
        ? Status.values[json['transaction_status']]
        : null;
    transactionId = json['transaction_id'];
    bankTransactionId = json['bank_transaction_id'];
    amount = json['amount'];
    createdTime = DateTimeHelper.parseAsUtc(json['created_time']);
    modifiedTime = DateTimeHelper.parseAsUtc(json['modified_time']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['amount'] = amount?.toInt();
    return data;
  }
}
