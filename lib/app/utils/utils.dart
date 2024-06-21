import 'package:intl/intl.dart';

String formatValue(double value) {
  final strValue = value.toStringAsFixed(2);
  return strValue;
  // print(strValue);
  // return strValue.replaceFirst('.0|.00', '');
}

String formatMonthToBr(DateTime date) {
  return DateFormat.MMMM('pt_BR').format(date);
}
