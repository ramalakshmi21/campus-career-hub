import 'package:intl/intl.dart';

class Formatters {
  static final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('MMM dd, yyyy ? hh:mm a');

  static String formatDate(DateTime date) => _dateFormat.format(date);
  static String formatDateTime(DateTime date) => _dateTimeFormat.format(date);

  static String formatLPA(double lpa) {
    if (lpa % 1 == 0) {
      return '?${lpa.toInt()} LPA';
    }
    return '?${lpa.toStringAsFixed(1)} LPA';
  }

  static String formatStipend(int monthlyStipend) {
    if (monthlyStipend <= 0) return 'Unpaid / Credit-based';
    final formatter = NumberFormat('#,##,###');
    return '?${formatter.format(monthlyStipend)} / mo';
  }
}
