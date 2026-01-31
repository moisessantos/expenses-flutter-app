import 'package:flutter_test/flutter_test.dart';
import 'package:expenses_app/models/expense.dart';
import 'package:expenses_app/repositories/expense_repository.dart';

/// Tests for countByExpenseType method in ExpenseRepository
class FakeExpenseRepository implements ExpenseRepository {
  final List<Expense> _data;

  FakeExpenseRepository(this._data);

  @override
  Future<List<Expense>> findAll(String userId) async => _data;

  @override
  Future<List<Expense>> findAllWithTypes(String userId) async => _data;

  @override
  Future<Expense?> findById(String id, String userId) async {
    try {
      return _data.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Expense>> findByExpenseType(
          String expenseTypeId, String userId) async =>
      _data.where((e) => e.expenseTypeId == expenseTypeId).toList();

  @override
  Future<int> countByExpenseType(String expenseTypeId, String userId) async =>
      _data.where((e) => e.expenseTypeId == expenseTypeId).length;

  @override
  Future<List<Expense>> findByDateRange(
      DateTime startDate, DateTime endDate, String userId) async {
    return _data
        .where((e) => !e.date.isBefore(startDate) && !e.date.isAfter(endDate))
        .toList();
  }

  @override
  Future<Expense> create(Expense expense, String userId) async {
    final created = expense.copyWith(id: 'test-id-${_data.length}');
    _data.add(created);
    return created;
  }

  @override
  Future<Expense> update(Expense expense, String userId) async {
    final idx = _data.indexWhere((e) => e.id == expense.id);
    if (idx >= 0) _data[idx] = expense;
    return expense;
  }

  @override
  Future<bool> delete(String id, String userId) async {
    final before = _data.length;
    _data.removeWhere((e) => e.id == id);
    return _data.length < before;
  }
}

void main() {
  group('ExpenseRepository - countByExpenseType', () {
    test('should return 0 when no expenses use the type', () async {
      final expenseRepo = FakeExpenseRepository([]);
      final count = await expenseRepo.countByExpenseType('type-1', 'test-user');
      expect(count, equals(0));
    });

    test('should return 1 when one expense uses the type', () async {
      final expenseTypeId = 'type-1';
      final expense = Expense(
        id: 'expense-1',
        title: 'Lunch',
        amount: 20.0,
        date: DateTime.now(),
        expenseTypeId: expenseTypeId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final expenseRepo = FakeExpenseRepository([expense]);
      final count =
          await expenseRepo.countByExpenseType(expenseTypeId, 'test-user');
      expect(count, equals(1));
    });

    test('should count multiple expenses using the same type', () async {
      final expenseTypeId = 'type-1';
      final expenses = [
        Expense(
          id: 'expense-1',
          title: 'Lunch',
          amount: 20.0,
          date: DateTime.now(),
          expenseTypeId: expenseTypeId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Expense(
          id: 'expense-2',
          title: 'Dinner',
          amount: 30.0,
          date: DateTime.now(),
          expenseTypeId: expenseTypeId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Expense(
          id: 'expense-3',
          title: 'Breakfast',
          amount: 15.0,
          date: DateTime.now(),
          expenseTypeId: expenseTypeId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final expenseRepo = FakeExpenseRepository(expenses);
      final count =
          await expenseRepo.countByExpenseType(expenseTypeId, 'test-user');
      expect(count, equals(3));
    });

    test('should not count expenses with different type', () async {
      final expenses = [
        Expense(
          id: 'expense-1',
          title: 'Lunch',
          amount: 20.0,
          date: DateTime.now(),
          expenseTypeId: 'type-1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Expense(
          id: 'expense-2',
          title: 'Transportation',
          amount: 30.0,
          date: DateTime.now(),
          expenseTypeId: 'type-2',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final expenseRepo = FakeExpenseRepository(expenses);

      final count1 =
          await expenseRepo.countByExpenseType('type-1', 'test-user');
      expect(count1, equals(1));

      final count2 =
          await expenseRepo.countByExpenseType('type-2', 'test-user');
      expect(count2, equals(1));

      final count3 =
          await expenseRepo.countByExpenseType('type-3', 'test-user');
      expect(count3, equals(0));
    });
  });
}
