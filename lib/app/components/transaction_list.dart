import 'package:flutter/material.dart';
import 'package:personal_expenses/app/components/transaction_list_item.dart';
import 'package:personal_expenses/app/models/transaction.dart';

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
              return TransactionListItem(
                transaction: tr,
                currentDate: currentDate,
                onRemove: (transaction) {
                  onRemoveTransaction(transaction);
                  Navigator.pop(context);
                },
              );
            },
          );
  }
}
