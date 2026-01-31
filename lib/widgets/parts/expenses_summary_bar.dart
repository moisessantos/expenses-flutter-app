import 'package:flutter/material.dart';
import 'package:expenses_app/l10n/app_localizations.dart';
import 'package:expenses_app/constants.dart';

class ExpensesSummaryBar extends StatelessWidget {
  final int count;
  final double totalAmount;

  const ExpensesSummaryBar(
      {super.key, required this.count, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kPadding16),
      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.totalExpenses(count),
            style: const TextStyle(
              fontSize: kMediumFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            AppLocalizations.of(context)!
                .totalAmount(totalAmount.toStringAsFixed(2)),
            style: const TextStyle(
              fontSize: kMediumFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
