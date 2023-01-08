class Endpoints {
  Endpoints._();
  static const String refreshToken = "";
  static const String config = "https://demo0033363.mockable.io/shop-app-demo";

  static const String checkUser = "/api/user/check";

  static String otpVerification() {
    return "/api/user/verify";
  }

  // admin api's starts here
  static const String adminLogin = "/api/user/admin_login";
  static const String createProduct = "/api/product/";
  static const String getProducts = "/api/product/";
  static const String createCategories = "/api/category/";
  static const String getCategories = "/api/category/";

  // admin api's ends here

  static const String addService = "/services/";
  static const String myServices = "/services/mine";
  static const String nearbyServices = "/services/nearby";
  static const String homeContent = "/categories/home";

  static const String createOrder = "/orders/";
  static const String getPendingOrders = "/orders/";
  static const String getReferrals = "/referrals";
  static const String getOrderHistory = "/orders/history/";
  static const String createCreditBuyOrder = "/payment/create_order";
  static const String verifyPayment = "/payment/verify_payment";
  static const String transferCredit = "/credit/";
  static const String getCreditHistory = "/credit/";
  static const String getTodaysIncome = "/payment/wallet-transactions";
  static const String createStaff = "/staff/";
  static const String getStaffs = "/staff/";
  static const String requestWithdrawal = "/payment/request_withdraw";
  static const String getPendingWithdrawals =
      "/payment/pending_withdrawal_requests";

  static String deleteService(int id) {
    return "/services/" + id.toString();
  }

  static String getOrder(int id) {
    return "/orders/" + id.toString();
  }

  static String saveOrder(int? id) {
    return "/orders/" + id.toString();
  }

  static String getProfile(int id) {
    return "/user/" + id.toString();
  }

  static String getProfileByPhone(String phone) {
    return "/user/find?phone=" + phone;
  }

  static String getProfileByReferralCode(String code) {
    return "/user/find?referralCode=" + code;
  }

  static String getDashboard(int id) {
    return "/user/dashboard/" + id.toString();
  }

  static String saveProfile(int id) {
    return "/user/" + id.toString();
  }
}
