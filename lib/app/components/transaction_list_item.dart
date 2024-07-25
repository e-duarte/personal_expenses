import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/app/components/tag_leading.dart';
import 'package:personal_expenses/app/components/transaction_dialog.dart';
import 'package:personal_expenses/app/models/transaction.dart';
import 'package:personal_expenses/app/utils/utils.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.currentDate,
    required this.onRemove,
  });

  final Transaction transaction;
  final DateTime currentDate;
  final void Function(Transaction) onRemove;

  double get currentTransactionValue {
    final value = transaction.value / transaction.installments;
    return transaction.owner == Owner.divided ? value / 2 : value;
  }

  String get ownerDescription {
    return switch (transaction.owner) {
      Owner.me => 'Eu',
      Owner.other => transaction.ownerDesc,
      Owner.divided => '',
    };
  }

  String get _installmentLegend {
    if (transaction.installments == 1) return '';

    final currentInstallment =
        (currentDate.month - transaction.date.month + 1).abs();

    return '$currentInstallment/${transaction.installments}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 7,
        minVerticalPadding: 0,
        onTap: () => _openTransactionDialog(context),
        leading: TagLeading(
          transaction.tag.iconPath,
          Color(int.parse(transaction.tag.color)),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.labelLarge,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (transaction.fixed)
                  Image.asset(
                    'assets/icons/pin_icon.png',
                    width: 18,
                    height: 18,
                  ),
                if (Owner.divided == transaction.owner)
                  Image.asset(
                    'assets/icons/divided_icon.png',
                    width: 20,
                    height: 20,
                  ),
                Text(
                  transaction.owner != Owner.divided
                      ? transaction.ownerText
                      : '',
                ),
                const SizedBox(width: 8),
                Text(transaction.paymentText),
                const SizedBox(width: 8),
                Text(_installmentLegend),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'R\$${formatValue(currentTransactionValue)}',
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              DateFormat('dd - MMM', 'pt_BR')
                  .format(transaction.date)
                  .replaceFirst('01', '1º')
                  .replaceFirst('-', 'de'),
            ),
          ],
        ),
      ),
    );
  }

  void _openTransactionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return TransactionDialog(
          transaction: transaction,
          onRemoveTransaction: onRemove,
        );
      },
    );
  }
}
