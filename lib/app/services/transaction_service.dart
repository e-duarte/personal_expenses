import 'package:personal_expenses/app/models/transaction.dart';
import 'package:personal_expenses/app/services/tag_service.dart';
import 'package:personal_expenses/app/utils/db_utils.dart';

class TransactionService {
  static const _table = 'transactions';

  Future<void> insertTransaction(Transaction transaction) async {
    final tagMap = transaction.tag.toMap();
    tagMap.removeWhere((key, value) => key == 'id');
    final tagId = await DbUtils.insertData('tags', tagMap);

    final transactionMap = transaction.toMap();
    transactionMap.removeWhere((key, value) => key == 'id');
    transactionMap['tag'] = tagId;

    await DbUtils.insertData(_table, transactionMap);
  }

  Future<List<Transaction>> getTransactions() async {
    final transactionsMaps = await DbUtils.listData(_table);
    final List<Transaction> transactions = [];

    for (var tr in transactionsMaps) {
      final tag = await TagService().getTag(tr['id'] as int);
      final Map<String, Object?> newMap = Map.from(tr);
      newMap['tag'] = tag.toMap();
      transactions.add(Transaction.fromMap(newMap));
    }
    return transactions;
  }
}
