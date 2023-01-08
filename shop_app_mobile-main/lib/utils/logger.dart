import 'package:logger/logger.dart';

CustomLogger getLogger(String className) {
  var logger = Logger(
    printer: PrettyPrinter(),
    filter: CustomFilter(),
  );
  return CustomLogger(className);
}

class CustomLogger {
  String className;
  Logger? logger;
  static bool calledBefore = false;
  CustomLogger(this.className) {
    logger =
        Logger(filter: CustomFilter(), printer: SimpleLogPrinter(className));
  }

  void v(dynamic message, [dynamic methodName, StackTrace? stackTrace]) {
    logger?.v(message);
    // FLog.info(
    //     className: className,
    //     text: message.toString() ?? "",
    //     methodName: methodName,
    //     stacktrace: stackTrace);
  }

  /// Log message at level [Level.debug].
  void d(dynamic message, [dynamic methodName, StackTrace? stackTrace]) {
    logger?.d(message);
    // FLog.debug(
    //     className: className,
    //     text: message.toString() ?? "",
    //     methodName: methodName,
    //     stacktrace: stackTrace);
  }

  /// Log message at level [Level.info].
  void i(dynamic message, [dynamic methodName, StackTrace? stackTrace]) {
    logger?.i(message);
    // FLog.info(
    //     className: className,
    //     text: message.toString() ?? "",
    //     methodName: methodName,
    //     stacktrace: stackTrace);
  }

  /// Log message at level [Level.warning].
  void w(dynamic message, [dynamic methodName, StackTrace? stackTrace]) {
    logger?.w(message);
    // FLog.warning(
    //     className: className,
    //     text: message.toString() ?? "",
    //     methodName: methodName,
    //     stacktrace: stackTrace);
  }

  /// Log message at level [Level.error].
  void e(dynamic message,
      [dynamic methodName, Exception? exception, StackTrace? stackTrace]) {
    logger?.e(message);
    // FLog.error(
    //     className: className,
    //     text: message.toString() ?? "",
    //     methodName: methodName,
    //     exception: exception,
    //     stacktrace: stackTrace);
  }

  /// Log message at level [Level.wtf].
  void wtf(dynamic message, [dynamic methodName, StackTrace? stackTrace]) {
    logger?.wtf(message);
    // FLog.debug(
    //     className: className,
    //     text: message.toString() ?? "",
    //     methodName: methodName,
    //     stacktrace: stackTrace);
  }
}

class SimpleLogPrinter extends LogPrinter {
  final String className;
  SimpleLogPrinter(this.className);
  @override
  List<String> log(LogEvent event) {
    return [event.message.toString()];
  }
}

class CustomFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    var shouldLog = false;
    assert(() {
      if (event.level.index >= Level.debug.index) {
        shouldLog = true;
      }
      return true;
    }());
    return shouldLog;
  }
}
