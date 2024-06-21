import 'package:flutter/material.dart';
import 'package:personal_expenses/app/components/tag_leading.dart';
import 'package:personal_expenses/app/models/transaction.dart';
import 'package:personal_expenses/app/utils/utils.dart';

class TransactionDialog extends StatelessWidget {
  const TransactionDialog({
    super.key,
    required this.transaction,
    required this.onRemoveTransaction,
  });

  final Transaction transaction;
  final void Function(Transaction) onRemoveTransaction;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => onRemoveTransaction(transaction),
                  icon: const Icon(
                    Icons.delete_outline_outlined,
                  ),
                ),
              ],
            ),
            TagLeading(
              transaction.tag.iconPath,
              Color(int.parse(transaction.tag.color)),
            ),
            Text(
              transaction.title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              'R\$${formatValue(transaction.owner == Owner.divided ? transaction.value / 2 : transaction.value)}',
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 3,
            ),
            Text(
              '${transaction.date.day} de ${formatMonthToBr(transaction.date)} de ${transaction.date.year}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            transaction.installments > 1
                ? Text('${transaction.installments}')
                : Text(
                    '1 parcela de R\$${formatValue(transaction.value)}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (transaction.fixed)
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/pin_icon.png',
                        width: 18,
                        height: 18,
                      ),
                      const Text('Fixado - '),
                    ],
                  ),
                transaction.owner == Owner.divided
                    ? Row(
                        children: [
                          Image.asset(
                            'assets/icons/divided_icon.png',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 5),
                          const Text('dividido - '),
                        ],
                      )
                    : Text('${transaction.owner.name} - '),
                Text(transaction.payment.name)
              ],
            ),
            if (transaction.pixDest.isNotEmpty)
              Text(
                'Enviado para ${transaction.pixDest}',
                maxLines: 3,
              ),
          ],
        ),
      ),
    );
  }
}
