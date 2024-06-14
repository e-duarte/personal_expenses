import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/app/components/transaction_dialog.dart';
import 'package:personal_expenses/app/models/transaction.dart';
import 'package:personal_expenses/app/components/tag_leading.dart';
import 'package:personal_expenses/app/utils/utils.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    super.key,
    required this.transactions,
    required this.currentDate,
    required this.onRemoveTransaction,
  });

  final DateTime currentDate;
  final List<Transaction> transactions;
  final void Function(Transaction) onRemoveTransaction;

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Center(
            child: Text(
              'Nenhuma Transação nesse mês',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          )
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tr = transactions[index];
              return Card(
                elevation: 0,
                color: Colors.white,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 7,
                  minVerticalPadding: 0,
                  onTap: () => _openTransactionDialog(
                    context,
                    tr,
                    (selectedTr) {
                      onRemoveTransaction(selectedTr);
                      Navigator.pop(context);
                    },
                  ),
                  leading: TagLeading(
                    tr.tag.iconPath,
                    Color(int.parse(tr.tag.color)),
                  ),
                  title: Text(
                    tr.title,
                    style: Theme.of(context).textTheme.labelLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (tr.fixed)
                            Image.asset(
                              'assets/icons/pin_icon.png',
                              width: 18,
                              height: 18,
                            ),
                          if (Owner.divided == tr.owner)
                            Image.asset(
                              'assets/icons/divided_icon.png',
                              width: 20,
                              height: 20,
                            ),
                          Text(
                            '${tr.owner == Owner.other ? tr.ownerDesc : tr.owner == Owner.me ? tr.owner.name : ''} - ${_getCurrentInstallment(tr)}/${tr.installments}',
                          ),
                        ],
                      ),
                      Text(tr.payment.name),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'R\$${tr.owner == Owner.divided ? formatValue(tr.value / 2) : formatValue(tr.value / tr.installments)}',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        DateFormat('dd - MMM', 'pt_BR')
                            .format(tr.date)
                            .replaceFirst('01', '1º')
                            .replaceFirst('-', 'de'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  int _getCurrentInstallment(Transaction transaction) {
    return (currentDate.month - transaction.date.month + 1).abs();
  }

  void _openTransactionDialog(
    BuildContext context,
    Transaction transaction,
    void Function(Transaction) removeTranscation,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return TransactionDialog(
          transaction: transaction,
          onRemoveTransaction: removeTranscation,
        );
      },
    );
  }
}
