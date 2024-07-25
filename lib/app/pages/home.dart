import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:personal_expenses/app/components/consume_chart.dart';
import 'package:personal_expenses/app/components/loading_widget.dart';
import 'package:personal_expenses/app/components/months_dropdown.dart';
import 'package:personal_expenses/app/components/setting_form.dart';
import 'package:personal_expenses/app/components/tags_chart.dart';
import 'package:personal_expenses/app/components/filter_pop_menu.dart';
import 'package:personal_expenses/app/components/transaction_form.dart';
import 'package:personal_expenses/app/components/transaction_list.dart';
import 'package:personal_expenses/app/models/settings.dart';
import 'package:personal_expenses/app/models/tag.dart';
import 'package:personal_expenses/app/models/transaction.dart';
import 'package:personal_expenses/app/services/settings_service.dart';
import 'package:personal_expenses/app/services/tag_service.dart';
import 'package:personal_expenses/app/services/transaction_service.dart';
import 'package:personal_expenses/app/utils/transactions_filter.dart';
import 'package:personal_expenses/app/utils/utils.dart';
import 'package:social_share/social_share.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime? _selectedMonth;
  Settings? _settings;

  List<Tag> _tags = [];

  List<Transaction>? _transactions;

  final List<Filter> _filters = [
    OwnerFilter('Dividido', Owner.divided),
    FixedFilter('Fixado', true),
    PaymentFilter('Pix', Payment.pix),
    PaymentFilter('PixCredit', Payment.pixCredit),
    PaymentFilter('Credit', Payment.credit),
    TagFilter('Ninos', 'Ninos'),
    TagFilter('Compras', 'Compras'),
    TagFilter('Mercado', 'Mercado'),
    TagFilter('Merenda', 'Merenda'),
    TagFilter('Refeição', 'Refeição'),
    TagFilter('Despesas', 'Despesas'),
    TagFilter('Reserva', 'Reserva'),
    TagFilter('Geral', 'Geral'),
    TagFilter('Terceiros', 'Terceiros'),
  ];

  final List<Filter> _activedFilters = [];

  List<Transaction> get _transactionByMonth {
    final filtred = _transactions!.where((tr) {
      return (tr.date.isBefore(_selectedMonth!) ||
              tr.date.month == _selectedMonth!.month ||
              tr.fixed) &&
          tr.date.year == _selectedMonth!.year;
    }).where((tr) {
      final trMonth = tr.date.month;
      final currentMonth = _selectedMonth!.month;

      return ((trMonth + tr.installments) > currentMonth) || tr.fixed;
    }).toList();

    filtred.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return filtred.reversed.toList();
  }

  List<Transaction> get _filtredTransactions {
    List<Transaction> filtered = [];

    for (var filter in _activedFilters) {
      filtered.addAll(filter.filter(_transactionByMonth));
    }

    return filtered.isEmpty ? _transactionByMonth : filtered;
  }

  double get _sumFiltredTransactions {
    return _filtredTransactions
        .where((tr) => tr.owner == Owner.me || tr.owner == Owner.divided)
        .fold(0.0, (sum, tr) {
      return sum +
          (tr.owner == Owner.divided
              ? tr.value / 2
              : tr.value / tr.installments);
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

    SettingsService().getSettings().then((settings) {
      setState(() {
        _settings = settings;
      });
    });

    TagService().getTags().then((value) {
      setState(() {
        _tags = value;
      });
    });

    TransactionService().getTransactions().then((trs) {
      setState(() {
        _transactions = trs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _settings == null
        ? const LoadingWidget()
        : _tags.isNotEmpty
            ? _transactions != null
                ? _buildHome(context)
                : const LoadingWidget()
            : const LoadingWidget();
  }

  Widget _buildHome(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final appBarHeight = mediaQuery.size.height * 0.05;
    final appBar = PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: AppBar(
        title: MonthsDropDown(
          month: _selectedMonth!,
          onChanged: (newMonth) {
            setState(() {
              _selectedMonth = newMonth;
            });
          },
        ),
        actions: [
          IconButton(
            onPressed: _openTransactionalModal,
            icon: const Icon(Icons.add),
            color: Theme.of(context).colorScheme.primary,
          ),
          IconButton(
            onPressed: _shareWhatsapp,
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: _shareTransactions,
            icon: const Icon(Icons.download_rounded),
          ),
          IconButton(
            onPressed: _openSettingsModal,
            icon: const Icon(Icons.settings),
          ),
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
            height: availableHeight * 0.36,
            width: mediaQuery.size.width,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final charts = [
                  ConsumeChart(
                    value: _settings!.monthValue,
                    transactions: _transactionByMonth,
                  ),
                  Center(
                    child: TagsChart(
                      transactions: _transactionByMonth,
                      tags: _tags,
                    ),
                  ),
                ];
                return CarouselSlider(
                  options: CarouselOptions(
                    height: constraints.maxHeight * 0.94,
                    enableInfiniteScroll: false,
                    viewportFraction: 0.95,
                    enlargeCenterPage: true,
                  ),
                  items: charts.map((chart) {
                    return Container(
                      width: constraints.maxWidth,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: chart,
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Container(
            height: availableHeight * 0.64,
            padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Transações',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Text(
                      'Soma: R\$${formatValue(_sumFiltredTransactions)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    FilterPopMenu(
                      data: FiltersMapper(_filters)
                          .mapFiltersActive(_activedFilters),
                      onFilterChanged: _filterTransactions,
                    ),
                  ],
                ),
                Expanded(
                  child: TransactionList(
                    currentDate: _selectedMonth!,
                    transactions: _filtredTransactions,
                    onRemoveTransaction: _removeTransaction,
                  ),
                ),
                Text(
                  '${_transactionByMonth.length} transações no mês',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openTransactionalModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) {
        return TransactionForm(
          onSubmit: _addNewTransaction,
        );
      },
    );
  }

  void _openSettingsModal() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SizedBox(
          child: SettingsForm(
            settings: _settings!,
            onSettingChanged: _updateSettings,
          ),
        );
      },
    );
  }

  String _toCsvFormat() {
    final List<List<String>> transactionRows = [];
    final header = [
      'Categoria',
      'Título',
      'Autor',
      'Parcelas',
      'Data',
      'Valor',
    ];

    transactionRows.add(header);

    for (var tr in _filtredTransactions) {
      transactionRows.add(tr.toCsvRow());
    }

    return const ListToCsvConverter().convert(transactionRows);
  }

  void _shareWhatsapp() async {
    final csv = _toCsvFormat();
    SocialShare.shareWhatsapp(csv);
  }

  void _shareTransactions() async {
    final csv = _toCsvFormat();

    final Directory downloadsDir = Directory('/storage/emulated/0/Download/');

    final file = File(
      '${downloadsDir.path}/despesas_${formatMonthToBr(_selectedMonth!)}.csv',
    );

    await file.writeAsString(csv);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Arquivo foi salvo em Downloads'),
      ),
    );
  }

  void _updateSettings(Settings settings) async {
    const id = 1;
    final newSettings = await SettingsService().update(id, settings);
    setState(() {
      _settings = newSettings;
    });
  }

  void _addNewTransaction(Transaction transaction) async {
    final newTransaction =
        await TransactionService().insertTransaction(transaction);
    setState(() {
      _transactions!.add(newTransaction);
    });
  }

  void _removeTransaction(Transaction transaction) async {
    await TransactionService().removeTransaction(transaction);

    setState(() {
      _transactions!.removeWhere((tr) => tr.id == transaction.id);
    });
  }

  void _filterTransactions(Map<String, bool> filterMap) {
    final filterName = filterMap.entries.first.key;
    final isActive = filterMap.entries.first.value;
    setState(() {
      if (isActive) {
        _activedFilters.add(
          _filters.firstWhere(
            (filter) => filter.name == filterName,
          ),
        );
      } else {
        _activedFilters.removeWhere(
          (filter) => filter.name == filterName,
        );
      }
    });
  }
}
