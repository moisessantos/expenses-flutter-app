import 'package:flutter/material.dart';
import 'package:expenses_app/l10n/app_localizations.dart';
import 'package:expenses_app/constants.dart';
import '../app_button.dart';

class EmptyExpensesView extends StatelessWidget {
  final String dateFilter;
  final VoidCallback onAdd;

  const EmptyExpensesView(
      {super.key, required this.dateFilter, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.receipt_long,
            size: kAvatarSize64,
            color: Colors.grey,
          ),
          const SizedBox(height: kPadding16),
          Text(
            dateFilter == 'all'
                ? (AppLocalizations.of(context)?.noExpenses ??
                    'No expenses found')
                : (AppLocalizations.of(context)?.noExpensesPeriod ??
                    'No expenses found for selected period'),
            style: const TextStyle(
              fontSize: kLargeFontSize,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: kPadding16),
          SizedBox(
            width: 220,
            child: AppButton(
              onPressed: onAdd,
              child: Text(AppLocalizations.of(context)?.addFirstExpense ??
                  'Add Your First Expense'),
            ),
          ),
        ],
      ),
    );
  }
}
