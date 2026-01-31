import '../../models/expense.dart';

/// Public helper to group expenses according to the same rules used by
/// `BarChartArea` so it can be unit tested.
Map<DateTime, Map<String, double>> groupExpensesBy(
    List<Expense> items, String dateFilter) {
  final Map<DateTime, Map<String, double>> map = {};

  DateTime keyFor(DateTime dt) {
    if (dateFilter == 'all') {
      return DateTime(dt.year, dt.month, 1);
    } else if (dateFilter == 'week' || dateFilter == 'custom') {
      return DateTime(dt.year, dt.month, dt.day);
    } else if (dateFilter == 'month') {
      // group by week starting Monday
      final weekStart = dt.subtract(Duration(days: dt.weekday - 1));
      return DateTime(weekStart.year, weekStart.month, weekStart.day);
    }
    return DateTime(dt.year, dt.month, 1);
  }

  for (final e in items) {
    final k = keyFor(e.date);
    final cat = e.expenseType?.name ?? 'Unknown';
    map.putIfAbsent(k, () => {});
    map[k]![cat] = (map[k]![cat] ?? 0) + e.amount;
  }

  final sorted = Map.fromEntries(
      map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  return sorted;
}
