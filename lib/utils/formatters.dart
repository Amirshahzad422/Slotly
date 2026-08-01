import 'package:intl/intl.dart';

class Formatters {
  static String currency(double amount) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return formatter.format(amount);
  }

  static String date(DateTime date) {
    return DateFormat('EEE, d MMM yyyy').format(date);
  }

  static String shortDate(DateTime date) {
    return DateFormat('d MMM').format(date);
  }

  static String dayName(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  static String dayNumber(DateTime date) {
    return DateFormat('dd').format(date);
  }

  static String duration(int minutes) {
    if (minutes < 60) {
      return '$minutes mins';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) {
      return '$hours hr${hours > 1 ? 's' : ''}';
    }
    return '$hours hr $mins mins';
  }
}
