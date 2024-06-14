import 'package:intl/intl.dart';

String formatValue(double value) {
  final strValue = value.toStringAsFixed(1);
  return strValue.replaceFirst('.0', '');
}

String formatMonthToBr(DateTime date) {
  return DateFormat.MMMM('pt_BR').format(date);
}
