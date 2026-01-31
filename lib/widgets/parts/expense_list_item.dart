import 'package:expenses_app/widgets/small_spacing.dart';
import 'package:flutter/material.dart';
import '../../models/expense.dart';
import 'package:expenses_app/constants.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;

  const ExpenseListItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: kPadding16,
        vertical: 4.0,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: expense.expenseType != null
              ? Color(
                  int.parse('0xFF${expense.expenseType!.color.substring(1)}'))
              : Colors.grey,
          child: Text(
            '${expense.amount.toStringAsFixed(0)}€',
            style: const TextStyle(
              color: kAvatarTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          expense.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expense.description ?? ''),
            const SizedBox(height: kPadding4),
            Row(
              children: [
                if (expense.expenseType != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Color(int.parse(
                          '0xFF${expense.expenseType!.color.substring(1)}')),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      expense.expenseType!.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: kSmallFontSize,
                      ),
                    ),
                  ),
                  const SmallSpacing(),
                ],
                Text(
                  '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: kSmallFontSize,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Text(
          '${expense.amount.toStringAsFixed(2)}€',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: kMediumFontSize,
          ),
        ),
      ),
    );
  }
}
