import 'package:intl/intl.dart';
import 'package:personal_expenses/app/models/tag.dart';

class Transaction {
  final int? id;
  final String title;
  final double value;
  final DateTime date;
  final bool fixed;
  final Tag tag;
  final int installments;
  final String others;
  final String payment;

  Transaction({
    this.id,
    required this.title,
    required this.value,
    required this.date,
    required this.fixed,
    required this.tag,
    required this.installments,
    required this.others,
    required this.payment,
  });

  factory Transaction.fromMap(Map<String, Object?> data) {
    return Transaction(
      id: data['id'] as int,
      title: data['title'] as String,
      value: data['value'] as double,
      date: DateFormat('dd/MM/yyyy').parse(data['date'] as String),
      fixed: data['fixed'] == 1,
      tag: Tag.fromMap(data['tag'] as Map<String, Object?>),
      installments: data['installments'] as int,
      others: data['others'] as String,
      payment: data['payment'] as String,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'date': DateFormat('dd/MM/yyyy').format(date),
      'fixed': fixed ? 1 : 0,
      'tag': tag.toMap(),
      'installments': installments,
      'others': others,
      'payment': payment,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}
