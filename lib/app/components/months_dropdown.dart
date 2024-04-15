import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class _MonthsDropDownState extends State<MonthsDropDown> {
  String? monthValue;

  @override
  void initState() {
    super.initState();

    monthValue = widget.initialMonth;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: monthValue,
      icon: const Icon(
        Icons.keyboard_arrow_down,
        size: 30,
      ),
      underline: Container(),
      style: Theme.of(context).textTheme.titleLarge,
      onChanged: (value) {
        setState(() {
          monthValue = value;
          widget.onChanged(value!);
        });
      },
      items: _months.map((month) {
        return DropdownMenuItem(
          value: month,
          child: Text(
            month,
          ),
        );
      }).toList(),
    );
  }

  List<String> get _months {
    return List.generate(12, (i) => i + 1)
        .map((i) {
          final date = DateTime(DateTime.now().year, i);
          return DateFormat.MMMM('pt_BR').format(date);
        })
        .map((month) => toBeginningOfSentenceCase(month)!)
        .toList();
  }
}

class MonthsDropDown extends StatefulWidget {
  const MonthsDropDown({
    super.key,
    required this.initialMonth,
    required this.onChanged,
  });

  final String? initialMonth;
  final void Function(String) onChanged;

  @override
  State<MonthsDropDown> createState() => _MonthsDropDownState();
}
