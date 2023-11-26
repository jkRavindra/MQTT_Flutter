import 'package:intl/intl.dart';

class DateUtilsClass {

  /// Get Date and Time with Expected formate
  /// Example :
  /// getDateTimeWithExpectedFormat('2023-08-04T13:45:42.589Z', 'MM-dd-yyyy h:mm a')
  /// Result => 08-04-2023 1:45 PM
  String getDateTimeWithExpectedFormat(String date, String expectedFormat) {
    final format = DateFormat(expectedFormat);
    DateTime dateTime = DateTime.parse(date);
    final a = format.format(dateTime);
    return a.toString();
  }

  /// Get Last Expected Date from Current Date
  /// Example :
  /// getPreviousExpectedDate(30) => 2023-07-06 12:29:55.633463
  DateTime getPreviousExpectedDate(int a) {
    DateTime currentDate = DateTime.now();
    DateTime previousDaysDate = currentDate.subtract(Duration(days: a));
    return previousDaysDate;
  }

  /// Get Feature Expected Date from Current Date
  /// Example :
  /// getFeatureExpectedDate(30) => 2023-09-04 12:33:15.663434
  DateTime getFeatureExpectedDate(int a) {
    DateTime currentDate = DateTime.now();
    DateTime featureDaysDate = currentDate.add(Duration(days: a));
    return featureDaysDate;
  }

  /// month format => 'MMMM yyyy'
  /// day format => 'dd'
  /// first day format => 'MMM dd'
  /// full day format => 'EEE MMM dd, yyyy'
  /// api day format => 'yyyy-MM-dd'

  static const List<String> weekdays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];

  /// Whether or not two times are on the same day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isSameWeek(DateTime a, DateTime b) {
    a = DateTime.utc(a.year, a.month, a.day);
    b = DateTime.utc(b.year, b.month, b.day);

    var diff = a.toUtc().difference(b.toUtc()).inDays;
    if (diff.abs() >= 7) {
      return false;
    }

    var min = a.isBefore(b) ? a : b;
    var max = a.isBefore(b) ? b : a;
    var result = max.weekday % 7 - min.weekday % 7 >= 0;
    return result;
  }

  DateTime previousMonth(DateTime m) {
    var year = m.year;
    var month = m.month;
    if (month == 1) {
      year--;
      month = 12;
    } else {
      month--;
    }
    return DateTime(year, month);
  }

  DateTime nextMonth(DateTime m) {
    var year = m.year;
    var month = m.month;

    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }
    return DateTime(year, month);
  }

  DateTime previousWeek(DateTime w) {
    return w.subtract(Duration(days: 7));
  }

  DateTime nextWeek(DateTime w) {
    return w.add(Duration(days: 7));
  }
}
