import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:personal_expenses/app/models/tag.dart';
import 'package:personal_expenses/app/models/transaction.dart';
import 'package:personal_expenses/app/utils/utils.dart';
import "dart:math";

class TagsChart extends StatelessWidget {
  const TagsChart({
    super.key,
    required this.tags,
    required this.transactions,
    required this.barColors,
  });

  final List<Tag> tags;
  final List<Transaction> transactions;
  final List<int> barColors;

  @override
  Widget build(BuildContext context) {
    const linesGrideNum = 4;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: transactions.isNotEmpty
          ? BarChart(
              BarChartData(
                borderData: FlBorderData(
                  show: true,
                  border: const Border.symmetric(
                    horizontal: BorderSide(
                      width: 0.1,
                    ),
                  ),
                ),
                alignment: BarChartAlignment.spaceBetween,
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: _maxValue / linesGrideNum,
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: _getValuesTitle(linesGrideNum),
                  bottomTitles: _getIconTitle(),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipMargin: 7,
                  ),
                ),
                barGroups: List.generate(_groupedValues.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: _groupedValues[index]['value'] as double,
                        color: Color(barColors[index]),
                      )
                    ],
                  );
                }),
              ),
            )
          : Center(
              child: Text(
                'No data',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
    );
  }

  List<int> get _tagIndexs {
    return List.generate(tags.length, (index) => index);
  }

  Map<int, String> get _getTitles {
    return {for (var index in _tagIndexs) index: tags[index].iconPath};
  }

  AxisTitles _getValuesTitle(int linesGrideNum) {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 45,
        interval: _maxValue / linesGrideNum,
        getTitlesWidget: (value, meta) {
          return SideTitleWidget(
            axisSide: meta.axisSide,
            child: FittedBox(
              child: Text(
                'R\$${formatValue(value)}',
                style: const TextStyle(fontSize: 10),
              ),
            ),
          );
        },
      ),
    );
  }

  AxisTitles _getIconTitle() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          return SideTitleWidget(
            axisSide: meta.axisSide,
            child: Image.asset(
              _getTitles[value]!,
            ),
          );
        },
      ),
    );
  }

  List<Map<String, Object?>> get _groupedValues {
    return tags.map((tag) {
      var totalSum = 0.0;
      for (var tr in transactions) {
        if (tr.tag.tag == tag.tag) totalSum += tr.value;
      }

      return {'tag': tag.tag, 'value': totalSum};
    }).toList();
  }

  double get _maxValue {
    return transactions.map((tr) => tr.value).reduce(max);
  }
}
