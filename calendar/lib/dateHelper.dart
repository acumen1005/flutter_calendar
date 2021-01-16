

class DateHelper {

  // final dateFormat = '2020-02-20 00:00:00';

  static final weakBriefs = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  static final monthBriefs = ["Jan.", "Feb.", "Mar.", "Apr.", "May.", "Jun.", "Jul.", "Aug.", "Sept.", "Oct.", "Nov.", "Dec."];

  static bool isLeapYear(int year) {
    return ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0); 
  }

  static DateTime now() {
    return DateTime.now();
  }

  static String genBarTitle(DateTime dateTime) {
    String month = monthBriefs[dateTime.month - 1];
    int year = dateTime.year;
    return '$month $year';
  }

  static String monthText(DateTime dateTime) {
    return monthBriefs[dateTime.month - 1];
  }

  static DateTime updateDay(DateTime dateTime, int updateDay) {
    final days = updateDay - dateTime.day;
    print(days);
    final date = dateTime.add(Duration(days: days));
    return date;
  }

  /// 上一个月
  static DateTime previousMonth(DateTime dateTime) {
    final date = dateTimeOfFirstDayInMonth(dateTime);
    final previousDate = date.subtract(Duration(days: 1));
    if (previousDate.month == now().month) {
      return now();
    }
    return dateTimeOfFirstDayInMonth(previousDate);
  }

  /// 下一个月
  static DateTime nextMonth(DateTime dateTime) {
    final date = dateTimeOfFirstDayInMonth(dateTime);
    final daysCount = daysCountOfMonth(dateTime);
    final nextDate = date.add(Duration(days: daysCount));
    if (nextDate.month == now().month) {
      return now();
    }
    return dateTimeOfFirstDayInMonth(nextDate);
  }

/// 下一个月
  static DateTime dateTimeOfFirstDayInMonth(DateTime dateTime) {
    final year = dateTime.year;
    final month = dateTime.month;
    DateTime date = new DateTime(year, month, 1);
    return date;
  }

  static DateTime dateTimeOfLastDayInMonth(DateTime dateTime) {
    final year = dateTime.year;
    final month = dateTime.month;
    final daysCount = daysCountOfMonth(dateTime);
    DateTime date = new DateTime(year, month, daysCount);
    return date;
  }

  static int weekIndexOfFirstDayInMonth(DateTime dateTime) {
    DateTime date = dateTimeOfFirstDayInMonth(dateTime);
    return date.weekday;
  }

  static int daysCountOfPreviousMonth(DateTime dateTime) {
    final date = dateTimeOfFirstDayInMonth(dateTime);
    final lastDate = date.subtract(Duration(days: 1));
    return daysCountOfMonth(lastDate);
  }

  static int daysCountOfMonth(DateTime dateTime) {
    final year = dateTime.year;
    final month = dateTime.month;
    final bigMonths = [1, 3, 5, 7, 8, 10, 12];
    if (month == 2) {
      return isLeapYear(year) ? 29 : 28;
    } else if (bigMonths.contains(month)) {
      return 31;
    } else {
      return 30;
    }
  }
}