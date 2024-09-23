class DateUtil {
  var now = DateTime.now();
  String today() {
    String today = '${now.year}-${now.month}-${now.day}';
    return today;
  }

  String yesterday() {
    String yesterday = '${now.year}-${now.month}-${now.day - 1}';
    return yesterday;
  }

  String getLastDayOfMonth(int year, int month) {
    DateTime firstDayOfNextMonth = DateTime(year, month + 1, 1);
    DateTime lastDay = firstDayOfNextMonth.subtract(const Duration(days: 1));
    return '${lastDay.year}-${lastDay.month}-${lastDay.day} 23:59:59';
  }

  String getFirstDayOfMonth(int year, int month) {
    DateTime firstDay = DateTime(year, month, 1);
    return '${firstDay.year}-${firstDay.month}-${firstDay.day} 00:00:00';
  }
}
