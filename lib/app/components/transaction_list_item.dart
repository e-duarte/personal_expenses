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
                  '${transaction.owner == Owner.other ? transaction.ownerDesc : transaction.owner == Owner.me ? transaction.owner.name : ''} - ${_getCurrentInstallment(transaction)}/${transaction.installments}',
                ),
              ],
            ),
            Text(transaction.payment.name),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'R\$${transaction.owner == Owner.divided ? formatValue(transaction.value / 2) : formatValue(transaction.value / transaction.installments)}',
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

  int _getCurrentInstallment(Transaction transaction) {
    return (currentDate.month - transaction.date.month + 1).abs();
  }
}
