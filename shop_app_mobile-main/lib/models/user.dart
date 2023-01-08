import 'package:uia_app/utils/date_time_helper.dart';
import 'package:uia_app/utils/settings.dart';

class User {
  int? id;
  String? name;
  String? phone;
  DateTime? dob;
  String? gender;
  int? parentUserId;
  String? parentReferralCode;
  String? profileUrl;
  bool? isOnline;
  String? doorNumber;
  String? buildingName;
  String? streetName;
  String? landmark;
  String? pincode;
  String? city;
  String? state;
  String? country;
  String? bankAccountNumber;
  String? ifscCode;
  String? bankName;
  String? branchName;
  String? upiId;
  String? referralCode;
  double? walletBalance;
  double? creditBalance;
  double? totalEarned;
  double? todaysIncome;
  DateTime? subscriptionEndDate;
  bool isNewUser = false;
  int? referredCount;
  int? serviceCount;
  int? orderCompletedCount;
  DateTime? joinedTime;

  User(
      {this.id,
      this.name,
      this.phone,
      this.dob,
      this.gender,
      this.parentUserId,
      this.profileUrl,
      this.isOnline,
      this.doorNumber,
      this.buildingName,
      this.streetName,
      this.landmark,
      this.pincode,
      this.city,
      this.state,
      this.country,
      this.bankAccountNumber,
      this.ifscCode,
      this.bankName,
      this.branchName,
      this.upiId,
      this.referralCode,
      this.walletBalance,
      this.creditBalance,
      this.totalEarned,
      this.subscriptionEndDate});
  double get totalWithdrawn => (totalEarned ?? 0) - (walletBalance ?? 0);

  User.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    dob = json['dob'] != null
        ? DateTimeHelper.parseReadableDate(json['dob'])
        : null;
    gender = json['gender'];
    parentUserId = json['parent_user_id'];
    profileUrl = json['profile_url'];
    isOnline = json['online_status'] == 1 ? true : false;
    doorNumber = json['door_number'];
    buildingName = json['building_name'];
    streetName = json['street_name'];
    landmark = json['landmark'];
    pincode = json['pincode'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    bankAccountNumber = json['bank_account_number'];
    ifscCode = json['ifsc_code'];
    bankName = json['bank_name'];
    branchName = json['branch_name'];
    upiId = json['upi_id'];
    referralCode = json['referral_code'];
    walletBalance = json['wallet_balance'];
    creditBalance = json['credit_balance'];
    totalEarned = json['total_earned'];
    referredCount = json['referred_count'];
    serviceCount = json['service_count'];
    orderCompletedCount = json['order_completed_count'];
    joinedTime = DateTimeHelper.parseAsUtc(json['created_time']);
    subscriptionEndDate =
        DateTimeHelper.parseAsUtc(json['subscription_end_date']);
    todaysIncome = json['todays_income'];
  }

  Map<String, dynamic> toMapForUpdate() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['name'] = name;
    data['phone'] = phone;
    data['dob'] = dob != null ? DateTimeHelper.getReadableDate(dob) : null;
    data['gender'] = gender;
    data['parent_user_id'] = parentUserId;
    data['profile_url'] = profileUrl;
    data['online_status'] = isOnline != null ? (isOnline! ? 1 : 0) : null;
    data['door_number'] = doorNumber;
    data['building_name'] = buildingName;
    data['street_name'] = streetName;
    data['landmark'] = landmark;
    data['pincode'] = pincode;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['bank_account_number'] = bankAccountNumber;
    data['ifsc_code'] = ifscCode;
    data['bank_name'] = bankName;
    data['branch_name'] = branchName;
    data['upi_id'] = upiId;
    data['referral_code'] = referralCode;
    data['wallet_balance'] = walletBalance;
    data['credit_balance'] = creditBalance;
    data['total_earned'] = totalEarned;

    data.removeWhere((key, value) => key == null || value == null);
    return data;
  }

  toMapForLogin({isResend = false}) {
    return {
      "mobile": phone,
      "is_resend_otp": isResend,
    };
  }
}
