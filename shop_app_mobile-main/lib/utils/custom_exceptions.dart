class CustomException implements Exception {
  String? cause;
  CustomException(this.cause) {
    cause = this.cause;
  }
  String toString() {
    print("Exception caught at Custom exception");
    if (cause == null) return "Exception";
    return "$cause";
  }
}
