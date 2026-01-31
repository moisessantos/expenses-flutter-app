import 'package:flutter/material.dart';
import 'package:expenses_app/l10n/app_localizations.dart';
import 'package:expenses_app/constants.dart';

typedef DateFilterChanged = void Function(
    String dateFilter, DateTime? start, DateTime? end);

class DateFilterWidget extends StatelessWidget {
  final String dateFilter;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateFilterChanged onChanged;

  const DateFilterWidget({
    super.key,
    required this.dateFilter,
    required this.startDate,
    required this.endDate,
    required this.onChanged,
  });

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
    );

    if (picked != null) {
      onChanged('custom', picked.start, picked.end);
    }
  }

  void _setDateFilter(String filter) {
    final now = DateTime.now();
    switch (filter) {
      case 'week':
        // current week starting Monday
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        onChanged('week',
            DateTime(weekStart.year, weekStart.month, weekStart.day), now);
        break;
      case 'last_week':
        // previous week (Monday to Sunday)
        final thisWeekStart = now.subtract(Duration(days: now.weekday - 1));
        final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));
        final lastWeekEnd = lastWeekStart.add(const Duration(days: 6));
        onChanged(
          'last_week',
          DateTime(lastWeekStart.year, lastWeekStart.month, lastWeekStart.day),
          DateTime(lastWeekEnd.year, lastWeekEnd.month, lastWeekEnd.day),
        );
        break;
      case 'month':
        // current month starting at 1st of this month
        final monthStart = DateTime(now.year, now.month, 1);
        onChanged('month', monthStart, now);
        break;
      case 'last_month':
        // previous calendar month
        final lastMonthStart = DateTime(now.year, now.month - 1, 1);
        final lastMonthEnd =
            DateTime(now.year, now.month, 1).subtract(const Duration(days: 1));
        onChanged(
          'last_month',
          DateTime(
              lastMonthStart.year, lastMonthStart.month, lastMonthStart.day),
          DateTime(lastMonthEnd.year, lastMonthEnd.month, lastMonthEnd.day),
        );
        break;
      case 'custom':
        // handled by date picker
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding16),
      child: ExpansionTile(
        title: Text(
            AppLocalizations.of(context)?.filterByDate ?? 'Filter by Date'),
        initiallyExpanded: false,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: kPadding8),
            child: Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: Text(
                      AppLocalizations.of(context)?.thisWeek ?? 'This Week'),
                  selected: dateFilter == 'week',
                  onSelected: (_) => _setDateFilter('week'),
                ),
                FilterChip(
                  label: Text(
                      AppLocalizations.of(context)?.lastWeek ?? 'Last Week'),
                  selected: dateFilter == 'last_week',
                  onSelected: (_) => _setDateFilter('last_week'),
                ),
                FilterChip(
                  label: Text(
                      AppLocalizations.of(context)?.thisMonth ?? 'This Month'),
                  selected: dateFilter == 'month',
                  onSelected: (_) => _setDateFilter('month'),
                ),
                FilterChip(
                  label: Text(
                      AppLocalizations.of(context)?.lastMonth ?? 'Last Month'),
                  selected: dateFilter == 'last_month',
                  onSelected: (_) => _setDateFilter('last_month'),
                ),
                FilterChip(
                  label: Text(dateFilter == 'custom'
                      ? (AppLocalizations.of(context)?.customRange ??
                          'Custom Range')
                      : (AppLocalizations.of(context)?.selectRange ??
                          'Select Range')),
                  selected: dateFilter == 'custom',
                  onSelected: (_) => _selectDateRange(context),
                ),
              ],
            ),
          ),
          if (dateFilter == 'custom' && startDate != null && endDate != null)
            Padding(
              padding: const EdgeInsets.only(bottom: kPadding8),
              child: Text(
                '${AppLocalizations.of(context)?.selectRange ?? 'Select Range'}: ${startDate!.day}/${startDate!.month}/${startDate!.year} - ${endDate!.day}/${endDate!.month}/${endDate!.year}',
                style: const TextStyle(
                    fontSize: kSmallFontSize, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
