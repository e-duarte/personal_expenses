import 'package:flutter/material.dart';
import 'package:personal_expenses/app/components/option_button.dart';

class ChartSelector extends StatelessWidget {
  const ChartSelector({
    super.key,
    required this.initialOption,
    required this.optionHandle,
  });

  final String initialOption;
  final void Function(String) optionHandle;

  @override
  Widget build(BuildContext context) {
    final options = ['Geral', 'Marcadores'];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OptionButton(
          label: options[0],
          color: _getColor(context, options[0]),
          textColor: _getTextColor(context, options[0]),
          onTap: _optionChanged,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        OptionButton(
          label: options[1],
          color: _getColor(context, options[1]),
          textColor: _getTextColor(context, options[1]),
          onTap: _optionChanged,
        ),
      ],
    );
  }

  void _optionChanged(String option) {
    optionHandle(option);
  }

  Color _getColor(BuildContext context, String option) {
    return initialOption == option
        ? Theme.of(context).colorScheme.primary
        : Colors.white;
  }

  Color _getTextColor(BuildContext context, String option) {
    return initialOption == option ? Colors.white : Colors.black;
  }
}
