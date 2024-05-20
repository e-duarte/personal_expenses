import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/app/components/chart_selector.dart';
import 'package:personal_expenses/app/components/consume_chart.dart';
import 'package:personal_expenses/app/components/months_dropdown.dart';
import 'package:personal_expenses/app/components/tags_chart.dart';
import 'package:personal_expenses/app/models/tag.dart';
import 'package:personal_expenses/app/models/transaction.dart';

class _HomeState extends State<Home> {
  String? _selectedMonth;
  String _selectedOption = 'Geral';
  double? _monthValue;
  final _tagColors = [
    0xFFF4DBB4,
    0xFFB4C4ED,
    0xFFB4EDBD,
    0xFFE8B4ED,
  ];
  final _tags = [
    Tag(
      tag: 'cats',
      iconPath: 'assets/icons/cats_icon.png',
    ),
    Tag(
      tag: 'compras',
      iconPath: 'assets/icons/compras_icon.png',
    ),
    Tag(
      tag: 'mercado',
      iconPath: 'assets/icons/mercado_icon.png',
    ),
    Tag(
      tag: 'merenda',
      iconPath: 'assets/icons/merenda_icon.png',
    ),
  ];

  final _transactions = [
    Transaction(
      title: 'Ração de 10k Wiskas',
      value: 220,
      date: DateTime(2024, 1, 1),
      fixed: false,
      tag: Tag(
        tag: 'cats',
        iconPath: 'assets/icons/cats_icon.png',
      ),
      installments: 1,
      others: '',
      payment: 'credit',
    ),
    Transaction(
      title: 'Ração wiskas',
      value: 19.99,
      date: DateTime.now(),
      fixed: false,
      tag: Tag(
        tag: 'cats',
        iconPath: 'assets/icons/cats_icon.png',
      ),
      installments: 1,
      others: '',
      payment: 'credit',
    ),
    Transaction(
      title: 'Tenis adidas',
      value: 419,
      date: DateTime.now(),
      fixed: false,
      tag: Tag(
        tag: 'compras',
        iconPath: 'assets/icons/compras_icon.png',
      ),
      installments: 4,
      others: '',
      payment: 'credit',
    ),
    Transaction(
      title: 'Shampoo e Condicionador',
      value: 45.7,
      date: DateTime.now(),
      fixed: false,
      tag: Tag(
        tag: 'mercado',
        iconPath: 'assets/icons/mercado_icon.png',
      ),
      installments: 1,
      others: 'vitor',
      payment: 'credit',
    ),
    Transaction(
      title: '1 coxinha e refri',
      value: 45.7,
      date: DateTime.now(),
      fixed: false,
      tag: Tag(
        tag: 'merenda',
        iconPath: 'assets/icons/merenda_icon.png',
      ),
      installments: 1,
      others: '',
      payment: 'credit',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _selectedMonth = toBeginningOfSentenceCase(
        DateFormat.MMMM('pt_BR').format(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    _monthValue = 3807.18;
    final mediaQuery = MediaQuery.of(context);

    final appBarHeight = mediaQuery.size.height * 0.05;
    final appBar = PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: AppBar(
        title: MonthsDropDown(
          initialMonth: _selectedMonth,
          onChanged: _changeMonth,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
    );

    final availableHeight =
        mediaQuery.size.height - appBarHeight - mediaQuery.padding.top;

    return Scaffold(
      appBar: appBar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: availableHeight * 0.04,
            child: ChartSelector(
              initialOption: _selectedOption,
              optionHandle: _changeChart,
            ),
          ),
          SizedBox(
            height: availableHeight * 0.36,
            width: double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: Container(
                    height: constraints.maxHeight * 0.94,
                    width: constraints.maxWidth * 0.94,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: _selectedOption == 'Geral'
                        ? ConsumeChart(
                            value: _monthValue!,
                            transactions: _getTransactionByMonth,
                          )
                        : Center(
                            child: TagsChart(
                              transactions: _getTransactionByMonth,
                              tags: _tags,
                              barColors: _tagColors,
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: availableHeight * 0.6,
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
          ),
        ],
      ),
    );
  }

  List<Transaction> get _getTransactionByMonth {
    return _transactions.where((tr) {
      final transactionMonth = toBeginningOfSentenceCase(
        DateFormat.MMMM('pt_BR').format(tr.date),
      );
      return transactionMonth == _selectedMonth;
    }).toList();
  }

  void _changeMonth(String month) {
    setState(() {
      _selectedMonth = month;
    });
  }

  void _changeChart(String option) {
    setState(() {
      _selectedOption = option;
    });
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
