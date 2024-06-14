import 'package:personal_expenses/app/models/transaction.dart';
import 'package:personal_expenses/app/services/tag_service.dart';
import 'package:personal_expenses/app/utils/db_utils.dart';

class TransactionService {
  static const _table = 'transactions';

  Future<Transaction> insertTransaction(Transaction transaction) async {
    final transactionId = await DbUtils.insertData(_table, transaction.toMap());
    return transaction.copyWith(id: transactionId);
  }

  Future<List<Transaction>> getTransactions() async {
    final transactionsMaps = await DbUtils.listData(_table);
    final List<Transaction> transactions = [];

    for (var tr in transactionsMaps) {
      final tag = await TagService().getTag(tr['tag'] as int);
      final Map<String, Object?> newMap = Map.from(tr);
      newMap['tag'] = tag.toMap();
      transactions.add(Transaction.fromMap(newMap));
    }
    return transactions;
  }

  Future<void> removeTransaction(Transaction transaction) async {
    await DbUtils.deleteData(_table, transaction.toMap());
  }
}
