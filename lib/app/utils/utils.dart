String formatValue(double value) {
  final strValue = value.toStringAsFixed(1);
  return strValue.replaceFirst('.0', '');
}
