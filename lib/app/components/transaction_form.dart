import 'package:flutter/material.dart';
import 'package:personal_expenses/app/components/date_picker.dart';
import 'package:personal_expenses/app/components/installments_dropdown.dart';
import 'package:personal_expenses/app/components/label_switch.dart';
import 'package:personal_expenses/app/components/radio_list.dart';
import 'package:personal_expenses/app/components/tags_radio_button.dart';
import 'package:personal_expenses/app/models/tag.dart';
import 'package:personal_expenses/app/models/transaction.dart';
import 'package:personal_expenses/app/services/tag_service.dart';

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  final _otherController = TextEditingController();
  final _pixDestController = TextEditingController();
  final _numberOfInstallments = 10;

  Payment _payment = Payment.pix;
  bool _fixed = false;
  int _selectedInstallments = 1;
  DateTime _selectedDate = DateTime.now();
  Owner _owner = Owner.me;
  String _ownerDesc = Owner.me.name;
  Tag? _selectedTag;

  List<Tag> _tags = [];

  @override
  void initState() {
    super.initState();

    TagService().getTags().then((value) {
      setState(() {
        _tags = value;
        _selectedTag = _tags.first;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: _tags.isNotEmpty
          ? _buildForm(context)
          : Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Nova Transação',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
              ),
              onSubmitted: (_) => _submitForm(),
            ),
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: 'Valor (R\$)',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _submitForm(),
            ),
            RadioList(
              data: const [
                {'title': 'Pix', 'value': Payment.pix},
                {'title': 'PixCredit', 'value': Payment.pixCredit},
                {'title': 'Credit', 'value': Payment.credit},
              ],
              groupValue: _payment,
              onChanged: (value) {
                setState(() {
                  _payment = value as Payment;
                });
              },
            ),
            if (_payment == Payment.pix || _payment == Payment.pixCredit)
              TextField(
                controller: _pixDestController,
                decoration: const InputDecoration(
                  labelText: 'Enviado para',
                ),
                onSubmitted: (_) => _submitForm(),
              ),
            if (_payment == Payment.credit)
              InstallmetsDropdown(
                transactionValue: double.tryParse(_valueController.text) ?? 0.0,
                numberOfInstallments: _numberOfInstallments,
                initialValue: _selectedInstallments,
                onChanged: (value) {
                  setState(() {
                    _selectedInstallments = value;
                  });
                },
              ),
            DatePicker(
              selectedDate: _selectedDate,
              onDateChanged: (newDate) {
                setState(() {
                  _selectedDate = newDate;
                });
              },
            ),
            RadioList(
              data: const [
                {'title': 'Eu', 'value': Owner.me},
                {'title': 'Dividido', 'value': Owner.divided},
                {'title': 'Outro', 'value': Owner.other},
              ],
              groupValue: _owner,
              onChanged: (value) {
                setState(() {
                  _owner = value as Owner;
                });
              },
            ),
            if (_owner == Owner.other)
              TextField(
                controller: _otherController,
                decoration: const InputDecoration(
                  labelText: 'Outro',
                ),
                onSubmitted: (_) => _submitForm(),
              ),
            LabelSwtich(
              label: 'Fixar Compra para os meses seguintes?',
              value: _fixed,
              onChanged: (value) {
                setState(() {
                  _fixed = value;
                });
              },
            ),
            TagsRadioButton(
              tags: _tags,
              initialTag: _selectedTag!,
              onChanged: (tag) {
                setState(() {
                  _selectedTag = tag;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    'Salvar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;
    final pixDest = _pixDestController.text;

    _ownerDesc = switch (_owner) {
      Owner.me => _owner.name,
      Owner.divided => _owner.name,
      Owner.other => _otherController.text,
    };

    if (title.isEmpty ||
        value <= 0 ||
        (_owner == Owner.other && _ownerDesc.isEmpty)) {
      return;
    }

    widget.onSubmit(
      Transaction(
        title: title,
        value: value,
        date: _selectedDate,
        fixed: _fixed,
        tag: _selectedTag!,
        installments: _selectedInstallments,
        owner: _owner,
        ownerDesc: _ownerDesc,
        payment: _payment,
        pixDest: pixDest,
      ),
    );

    Navigator.pop(context);
  }
}

class TransactionForm extends StatefulWidget {
  const TransactionForm({
    super.key,
    required this.onSubmit,
  });

  final void Function(Transaction) onSubmit;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}
