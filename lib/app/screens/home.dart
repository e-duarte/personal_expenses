import 'package:flutter/material.dart';
import 'package:personal_expenses/app/components/chart_selector.dart';
import 'package:personal_expenses/app/components/consume_chart.dart';
import 'package:personal_expenses/app/components/months_dropdown.dart';
import 'package:personal_expenses/app/components/setting_form.dart';
import 'package:personal_expenses/app/components/tags_chart.dart';
import 'package:personal_expenses/app/components/transaction_filter_menu.dart';
import 'package:personal_expenses/app/components/transaction_form.dart';
import 'package:personal_expenses/app/components/transaction_list.dart';
import 'package:personal_expenses/app/models/settings.dart';
import 'package:personal_expenses/app/models/tag.dart';
import 'package:personal_expenses/app/models/transaction.dart';
import 'package:personal_expenses/app/services/settings_service.dart';
import 'package:personal_expenses/app/services/tag_service.dart';
import 'package:personal_expenses/app/services/transaction_service.dart';
import 'package:personal_expenses/app/utils/utils.dart';
import 'package:social_share/social_share.dart';

class _HomeState extends State<Home> {
  DateTime? _selectedMonth;
  String _selectedOption = 'Geral';
  Settings? _settings;

  List<Tag> _tags = [];

  List<Transaction>? _transactions;

  Map<String, bool> _filter = {
    'Dividido': false,
    'Fixado': false,
    'Ninos': false,
    'Compras': false,
    'Mercado': false,
    'Merenda': false,
    'Refeição': false,
    'Despesas': false,
    'Reserva': false,
    'Geral': false,
    'Terceiros': false,
  };

  List<Transaction> get _getTransactionByMonth {
    return _transactions!.where((tr) {
      return (tr.date.isBefore(_selectedMonth!) ||
              tr.date.month == _selectedMonth!.month ||
              tr.fixed) &&
          tr.date.year == _selectedMonth!.year;
    }).where((tr) {
      final trMonth = tr.date.month;
      final currentMonth = _selectedMonth!.month;

      return ((trMonth + tr.installments) > currentMonth) || tr.fixed;
    }).toList();
  }

  List<Transaction> get _getFiltredTransaction {
    List<Transaction> filtred = [];

    if (_filter['Dividido'] == false &&
        _filter['Fixado'] == false &&
        _filter['Ninos'] == false &&
        _filter['Compras'] == false &&
        _filter['Mercado'] == false &&
        _filter['Merenda'] == false &&
        _filter['Refeição'] == false &&
        _filter['Despesas'] == false &&
        _filter['Reserva'] == false &&
        _filter['Geral'] == false &&
        _filter['Terceiros'] == false) {
      return _getTransactionByMonth;
    }

    for (var tr in _getTransactionByMonth) {
      if (_filter['Dividido']!) {
        if (tr.owner == Owner.divided) {
          if (!filtred.contains(tr)) filtred.add(tr);
        }
      }

      if (_filter['Fixado']!) {
        if (tr.fixed) {
          if (!filtred.contains(tr)) filtred.add(tr);
        }
      }

      for (var tag in [
        'Ninos',
        'Compras',
        'Mercado',
        'Merenda',
        'Refeição',
        'Despesas',
        'Reserva',
        'Geral',
        'Terceiros',
      ]) {
        _filtreTransactionByTag(filtred, tr, tag);
      }
    }

    return filtred;
  }

  double get _sumFiltredTransactions {
    return _getFiltredTransaction.fold(0.0, (t1, t2) {
      return t1 + (t2.owner == Owner.divided ? t2.value / 2 : t2.value);
    });
  }

  void _filtreTransactionByTag(
      List<Transaction> filtreds, Transaction tr, String tag) {
    if (_filter[tag]!) {
      if (tr.tag.tag == tag) {
        if (!filtreds.contains(tr)) filtreds.add(tr);
      }
    }
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
        ? _loadingScreen()
        : _tags.isNotEmpty
            ? _transactions != null
                ? _buildHome()
                : _loadingScreen()
            : _loadingScreen();
  }

  Widget _buildHome() {
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
            onPressed: _shareTransaction,
            icon: const Icon(Icons.share),
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
            height: availableHeight * 0.04,
            child: ChartSelector(
              initialOption: _selectedOption,
              optionHandle: (String option) {
                setState(() {
                  _selectedOption = option;
                });
              },
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
                            value: _settings!.monthValue,
                            transactions: _getTransactionByMonth,
                          )
                        : Center(
                            child: TagsChart(
                              transactions: _getTransactionByMonth,
                              tags: _tags,
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
            child: Column(
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    TransactionFilterMenu(
                      data: _filter,
                      onFilterChanged: (filter) {
                        setState(() {
                          _filter = filter;
                        });
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: TransactionList(
                    currentDate: _selectedMonth!,
                    transactions: _getFiltredTransaction,
                    onRemoveTransaction: _removeTransaction,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingScreen() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _openTransactionalModal() {
    showModalBottomSheet(
      context: context,
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

  void _shareTransaction() {
    String sharedText = _getFiltredTransaction.fold('', (text, tr) {
      return '$text ${tr.toWhatsapp()}\n\n';
    });
    SocialShare.shareWhatsapp(sharedText);
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
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
