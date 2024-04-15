import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/app/components/chart_options.dart';
import 'package:personal_expenses/app/components/months_dropdown.dart';

class _HomeState extends State<Home> {
  String? _selectedMonth;
  String _selectedOption = 'Geral';

  @override
  void initState() {
    super.initState();

    _selectedMonth = toBeginningOfSentenceCase(
        DateFormat.MMMM('pt_BR').format(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
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
            child: ChartOptions(
              initialOption: _selectedOption,
              optionHandle: _changeChart,
            ),
          ),
          Container(
            height: availableHeight * 0.41,
            color: Colors.white,
          ),
          Container(
            height: availableHeight * 0.55,
            color: Colors.blue,
          ),
        ],
      ),
    );
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
