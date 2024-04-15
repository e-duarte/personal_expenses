import 'package:flutter/material.dart';
import 'package:personal_expenses/app/components/option_button.dart';

class ChartOptions extends StatelessWidget {
  const ChartOptions({
    super.key,
    required this.initialOption,
    required this.optionHandle,
  });

  final String initialOption;
  final void Function(String) optionHandle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OptionButton(
          label: 'Geral',
          color: _getColor(context, 'Geral'),
          textColor: _getTextColor(context, 'Geral'),
          onTap: _optionChanged,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        OptionButton(
          label: 'Mês',
          color: _getColor(context, 'Mês'),
          textColor: _getTextColor(context, 'Mês'),
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
