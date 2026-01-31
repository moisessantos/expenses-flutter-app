import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import '../../models/expense.dart';
import 'package:expenses_app/constants.dart';
import 'group_by.dart';
import 'color_resolver.dart';

class BarChartArea extends StatelessWidget {
  final List<Expense> expenses;
  final String dateFilter; // 'all', 'week', 'month', 'custom'
  final ColorResolver colorFromHexOrFallback;

  const BarChartArea(
      {super.key,
      required this.expenses,
      required this.dateFilter,
      required this.colorFromHexOrFallback});

  // Helper: month names
  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  String _labelFor(DateTime dt) {
    if (dateFilter == 'all') {
      return '${_monthNames[dt.month - 1]} ${dt.year}';
    } else if (dateFilter == 'week') {
      return '${dt.day}/${dt.month}';
    } else if (dateFilter == 'month') {
      // show week start
      return '${dt.day}/${dt.month}';
    } else {
      return '${dt.day}/${dt.month}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupExpensesBy(expenses, dateFilter);
    if (grouped.isEmpty) {
      return SizedBox(
        height: kChartHeight / 2.5,
        child: Center(
          child: Text(
            'No data to display',
            style: TextStyle(
              fontSize: kMediumFontSize,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ),
      );
    }

    final categorySet = <String>{};
    for (final e in expenses) {
      categorySet.add(e.expenseType?.name ?? 'Unknown');
    }
    final categories = categorySet.toList()..sort();

    final Map<String, Color> categoryColor = {};
    for (final e in expenses) {
      final name = e.expenseType?.name ?? 'Unknown';
      if (!categoryColor.containsKey(name)) {
        categoryColor[name] = colorFromHexOrFallback(e.expenseType?.color);
      }
    }

    final bars = <BarChartGroupData>[];
    final labels = <String>[];
    int i = 0;
    for (final entry in grouped.entries) {
      final groupMap = entry.value; // Map<String,double>
      double cumulative = 0.0;
      final stackItems = <BarChartRodStackItem>[];
      for (final cat in categories) {
        final val = groupMap[cat] ?? 0.0;
        if (val <= 0) continue;
        final start = cumulative;
        cumulative += val;
        final end = cumulative;
        stackItems.add(BarChartRodStackItem(start, end,
            categoryColor[cat] ?? Theme.of(context).colorScheme.primary));
      }

      bars.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(toY: cumulative, rodStackItems: stackItems)
      ]));
      labels.add(_labelFor(entry.key));
      i++;
    }

    double maxTotal = 0.0;
    if (bars.isNotEmpty) {
      maxTotal = bars.map((b) => b.barRods.first.toY).reduce(math.max);
    }

    final sampleLabel = '${maxTotal.toStringAsFixed(0)}€';
    const double avgCharWidth = 8.0; // pixels per char estimate
    final reservedSize = sampleLabel.length * avgCharWidth + kPadding16;

    return SizedBox(
      height: kChartHeight,
      child: BarChart(
        BarChartData(
          barGroups: bars,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= labels.length) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(labels[idx],
                              style: const TextStyle(fontSize: 10)));
                    })),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: reservedSize,
                    interval: maxTotal > 0 ? maxTotal / 5 : 1,
                    getTitlesWidget: (value, meta) {
                      final label = '${value.toStringAsFixed(0)}€';
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child:
                            Text(label, style: const TextStyle(fontSize: 10)),
                      );
                    })),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
