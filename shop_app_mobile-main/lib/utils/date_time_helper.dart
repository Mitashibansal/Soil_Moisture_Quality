import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateTimeHelper {
  static String getReadableDate(DateTime? datetime) {
    return DateFormat.yMMMMd().format(datetime!);
  }

  static String getReadableTime(DateTime? datetime) {
    return DateFormat.jm().format(datetime!);
  }

  static String getReadableDateShort(DateTime? datetime) {
    return DateFormat.yMMMd().format(datetime!);
  }

  static DateTime? parseReadableDate(String? dateText) {
    return DateFormat.yMMMMd().parse(dateText!);
  }

  static String getReadableDateTime(DateTime? datetime) {
    return DateFormat.yMMMMd().add_jm().format(datetime!);
  }

  static parseAsUtc(String? dateTIme) {
    return dateTIme != null
        ? DateTime.tryParse(dateTIme + "Z")?.toLocal()
        : null;
  }

  static String getTimeAgo(DateTime? datetime) {
    return timeago.format(datetime!);
  }
}
