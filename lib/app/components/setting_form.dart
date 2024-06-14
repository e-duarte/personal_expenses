import 'package:flutter/material.dart';
import 'package:personal_expenses/app/components/save_button.dart';
import 'package:personal_expenses/app/models/settings.dart';
import 'package:personal_expenses/app/utils/utils.dart';

class _SettingsFormState extends State<SettingsForm> {
  TextEditingController? _monthValueController;
  @override
  void initState() {
    super.initState();
    _monthValueController = TextEditingController(
      text: formatValue(widget.settings.monthValue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: [
            TextField(
              controller: _monthValueController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _submitForm(),
              decoration: const InputDecoration(
                labelText: 'Salário (R\$)',
              ),
            ),
            SaveButton(onPressed: _submitForm),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    final monthValue = double.tryParse(_monthValueController!.text) ?? 0.0;

    widget.onSettingChanged(
      Settings(
        monthValue: monthValue,
      ),
    );

    Navigator.pop(context);
  }
}

class SettingsForm extends StatefulWidget {
  const SettingsForm({
    super.key,
    required this.settings,
    required this.onSettingChanged,
  });

  final Settings settings;
  final void Function(Settings) onSettingChanged;

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}
