import 'package:flutter/material.dart';
import 'package:personal_expenses/app/components/tag_leading.dart';
import 'package:personal_expenses/app/models/transaction.dart';
import 'package:personal_expenses/app/utils/utils.dart';

class TransactionDetail extends StatelessWidget {
  const TransactionDetail({
    super.key,
    required this.transaction,
  });

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final isDivided = transaction.owner == Owner.divided;
    final valueByinstallment = transaction.value / transaction.installments;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TagLeading(transaction.tag),
        Text(
          transaction.title,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        Text(
          'R\$${formatValue(isDivided ? valueByinstallment / 2 : valueByinstallment)}',
          textAlign: TextAlign.center,
          maxLines: 3,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          '${transaction.date.day} de ${formatMonthToBr(transaction.date)} de ${transaction.date.year}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        transaction.installments > 1
            ? Text(
                '${transaction.installments} parcelas R\$${formatValue(isDivided ? valueByinstallment / 2 : valueByinstallment)}',
                textAlign: TextAlign.center,
              )
            : Text(
                '1 parcela de R\$${formatValue(transaction.value)}',
                textAlign: TextAlign.center,
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
                  const Text(
                    'Fixado - ',
                    textAlign: TextAlign.center,
                  ),
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
                      Text(
                        '${transaction.ownerText} - ',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : Text('${transaction.ownerText} - '),
            Text(
              transaction.paymentText,
              textAlign: TextAlign.center,
            )
          ],
        ),
        if (transaction.pixDest.isNotEmpty)
          Text(
            'Enviado para ${transaction.pixDest}',
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
