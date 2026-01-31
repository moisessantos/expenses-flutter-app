import 'package:flutter/material.dart';
import '../../models/expense.dart';
import 'package:expenses_app/constants.dart';
import 'color_resolver.dart';

class ChartLegend extends StatelessWidget {
  final List<Expense> expenses;
  final ColorResolver colorFromHexOrFallback;

  const ChartLegend(
      {super.key,
      required this.expenses,
      required this.colorFromHexOrFallback});

  @override
  Widget build(BuildContext context) {
    final Map<String, Color> typeColors = {};
    for (final expense in expenses) {
      final typeName = expense.expenseType?.name ?? 'Unknown';
      final typeColor = colorFromHexOrFallback(expense.expenseType?.color);
      typeColors[typeName] = typeColor;
    }
    if (typeColors.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: kPadding8,
      runSpacing: kPadding4,
      children: typeColors.entries.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(right: kPadding4),
              decoration: BoxDecoration(
                color: entry.value,
                shape: BoxShape.circle,
              ),
            ),
            Text(
              entry.key,
              style: TextStyle(
                fontSize: kSmallFontSize,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
