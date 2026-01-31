import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/expense.dart';
import 'package:expenses_app/constants.dart';
import 'color_resolver.dart';

class PieChartArea extends StatelessWidget {
  final List<Expense> expenses;
  final ColorResolver colorFromHexOrFallback;

  const PieChartArea(
      {super.key,
      required this.expenses,
      required this.colorFromHexOrFallback});

  List<PieChartSectionData> _getPieChartData(BuildContext context) {
    final Map<String, double> typeAmounts = {};
    final Map<String, Color> typeColors = {};

    for (final expense in expenses) {
      final typeName = expense.expenseType?.name ?? 'Unknown';
      final typeColor = colorFromHexOrFallback(expense.expenseType?.color);

      typeAmounts[typeName] = (typeAmounts[typeName] ?? 0) + expense.amount;
      typeColors[typeName] = typeColor;
    }

    final total = expenses.fold<double>(0.0, (sum, e) => sum + e.amount);
    if (total == 0) return [];

    return typeAmounts.entries.map((entry) {
      return PieChartSectionData(
        color: typeColors[entry.key] ??
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
        value: entry.value,
        title: '${entry.value.toStringAsFixed(2)}€',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final chartData = _getPieChartData(context);

    if (chartData.isEmpty) {
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

    return SizedBox(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: chartData,
          centerSpaceRadius: 32,
          sectionsSpace: 2,
        ),
      ),
    );
  }
}
