import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expenses_app/widgets/view_expenses_parts.dart';
import 'package:expenses_app/widgets/view_expenses_parts.dart' as parts;
import 'package:expenses_app/models/expense.dart';
import 'package:expenses_app/models/expense_type.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('BarChartArea shows legend and stacked bars by category',
      (WidgetTester tester) async {
    final now = DateTime.now();

    final typeA = ExpenseType(
      id: 'test-type-a',
      name: 'Food',
      description: 'Food',
      color: '#FF0000',
      createdAt: now,
      updatedAt: now,
    );

    final typeB = ExpenseType(
      id: 'test-type-b',
      name: 'Transport',
      description: 'Transport',
      color: '#00FF00',
      createdAt: now,
      updatedAt: now,
    );

    final typeC = ExpenseType(
      id: 'test-type-c',
      name: 'Utilities',
      description: 'Utilities',
      color: '#0000FF',
      createdAt: now,
      updatedAt: now,
    );

    final expenses = [
      Expense(
        id: 'test-expense-1',
        title: 'Lunch',
        amount: 12.5,
        date: now.subtract(const Duration(days: 2)),
        expenseTypeId: typeA.id,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
        expenseType: typeA,
      ),
      Expense(
        id: 'test-expense-2',
        title: 'Bus',
        amount: 3.0,
        date: now.subtract(const Duration(days: 1)),
        expenseTypeId: typeB.id,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
        expenseType: typeB,
      ),
      Expense(
        id: 'test-expense-3',
        title: 'Electric',
        amount: 30.0,
        date: now,
        expenseTypeId: typeC.id,
        createdAt: now,
        updatedAt: now,
        expenseType: typeC,
      ),
    ];

    // Build widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ChartLegend(
                expenses: expenses,
                colorFromHexOrFallback: (hex) {
                  if (hex == null) return Colors.grey;
                  final cleaned = hex.startsWith('#') ? hex.substring(1) : hex;
                  return Color(int.parse('0xFF$cleaned'));
                },
              ),
              BarChartArea(
                expenses: expenses,
                dateFilter: 'week',
                colorFromHexOrFallback: (hex) {
                  if (hex == null) return Colors.grey;
                  final cleaned = hex.startsWith('#') ? hex.substring(1) : hex;
                  return Color(int.parse('0xFF$cleaned'));
                },
              ),
            ],
          ),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    // Assert legend shows the three category names
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('Transport'), findsOneWidget);
    expect(find.text('Utilities'), findsOneWidget);

    // There should be at least one BarChart widget
    expect(find.byType(BarChart), findsOneWidget);

    // Verify grouping helper produces expected groups for 'week'
    final grouped = parts.groupExpensesBy(expenses, 'week');
    // We expect three distinct day keys (each expense on a different day)
    expect(grouped.keys.length, equals(3));

    // Flatten totals by category across groups
    final totals = <String, double>{};
    grouped.forEach((_, map) {
      map.forEach((k, v) {
        totals[k] = (totals[k] ?? 0) + v;
      });
    });

    expect(totals['Food'], equals(12.5));
    expect(totals['Transport'], equals(3.0));
    expect(totals['Utilities'], equals(30.0));
  });
}
