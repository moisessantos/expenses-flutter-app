import 'package:expenses_app/repositories/preferences_repository.dart';
import '../di/dependency_container.dart';
import '../models/expense.dart';
import '../models/expense_type.dart';
import '../repositories/expense_repository.dart';
import '../repositories/expense_type_repository.dart';

class ExpenseService {
  final ExpenseRepository _expenseRepository;
  final ExpenseTypeRepository _expenseTypeRepository;
  late final PreferencesRepository _preferencesRepository;

  ExpenseService(this._expenseRepository, this._expenseTypeRepository,
      [PreferencesRepository? preferencesRepository]) {
    _preferencesRepository =
        preferencesRepository ?? DependencyContainer().preferencesRepository;
  }

  Future<List<Expense>> getAllExpenses() async {
    final savedUserId = await _preferencesRepository.loadUserId();
    if (savedUserId == null) return [];
    return await _expenseRepository.findAllWithTypes(savedUserId);
  }

  Future<List<Expense>> getExpensesByDateRange(
      DateTime startDate, DateTime endDate) async {
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Start date must be before or equal to end date');
    }
    final savedUserId = await _preferencesRepository.loadUserId();
    if (savedUserId == null) return [];
    return await _expenseRepository.findByDateRange(
        startDate, endDate, savedUserId);
  }

  Future<List<Expense>> getExpensesByType(String expenseTypeId) async {
    final savedUserId = await _preferencesRepository.loadUserId();
    if (savedUserId == null) return [];
    return await _expenseRepository.findByExpenseType(
        expenseTypeId, savedUserId);
  }

  Future<Expense?> getExpenseById(String id) async {
    final savedUserId = await _preferencesRepository.loadUserId();
    if (savedUserId == null) return null;
    return await _expenseRepository.findById(id, savedUserId);
  }

  Future<Expense> createExpense({
    required String title,
    String? description,
    required double amount,
    required DateTime date,
    required String expenseTypeId,
  }) async {
    // Validate inputs
    if (title.trim().isEmpty) {
      throw ArgumentError('Expense title cannot be empty');
    }
    if (amount <= 0) {
      throw ArgumentError('Expense amount must be greater than zero');
    }
    if (date.isAfter(DateTime.now())) {
      throw ArgumentError('Expense date cannot be in the future');
    }

    final now = DateTime.now();
    final expense = Expense(
      title: title.trim(),
      description: description?.trim(),
      amount: amount,
      date: date,
      expenseTypeId: expenseTypeId,
      createdAt: now,
      updatedAt: now,
    );

    final savedUserId = await _preferencesRepository.loadUserId();
    if (savedUserId == null) throw Exception('No authenticated user');
    return await _expenseRepository.create(expense, savedUserId);
  }

  Future<Expense> updateExpense(Expense expense) async {
    if (expense.id == null) {
      throw ArgumentError('Cannot update expense without ID');
    }

    // Validate inputs
    if (expense.title.trim().isEmpty) {
      throw ArgumentError('Expense title cannot be empty');
    }
    if (expense.amount <= 0) {
      throw ArgumentError('Expense amount must be greater than zero');
    }
    if (expense.date.isAfter(DateTime.now())) {
      throw ArgumentError('Expense date cannot be in the future');
    }

    // Verify that the expense type exists if provided
    final savedUserId = await _preferencesRepository.loadUserId();
    if (savedUserId == null) throw Exception('No authenticated user');

    if (expense.expenseTypeId != null) {
      final expenseType = await _expenseTypeRepository.findById(
          expense.expenseTypeId!, savedUserId);
      if (expenseType == null) {
        throw ArgumentError('Invalid expense type ID');
      }
    }

    final updatedExpense = expense.copyWith(
      title: expense.title.trim(),
      description: expense.description?.trim(),
    );

    return await _expenseRepository.update(updatedExpense, savedUserId);
  }

  Future<bool> deleteExpense(String id) async {
    final savedUserId = await _preferencesRepository.loadUserId();
    if (savedUserId == null) return false;
    return await _expenseRepository.delete(id, savedUserId);
  }

  // Analytics methods
  Future<double> getTotalExpensesForPeriod(
      DateTime startDate, DateTime endDate) async {
    final expenses = await getExpensesByDateRange(startDate, endDate);
    return expenses.fold<double>(
        0.0, (double total, Expense expense) => total + expense.amount);
  }

  Future<Map<ExpenseType, double>> getExpensesByTypeForPeriod(
      DateTime startDate, DateTime endDate) async {
    final expenses = await getExpensesByDateRange(startDate, endDate);
    final savedUserId = await _preferencesRepository.loadUserId();
    if (savedUserId == null) return {};
    final expenseTypes = await _expenseTypeRepository.findAll(savedUserId);

    final Map<ExpenseType, double> result = {};

    for (final expenseType in expenseTypes) {
      final typeExpenses = expenses
          .where((expense) => expense.expenseTypeId == expenseType.id)
          .toList();
      final total = typeExpenses.fold<double>(
          0.0, (double sum, Expense expense) => sum + expense.amount);
      if (total > 0) {
        result[expenseType] = total;
      }
    }

    return result;
  }

  Future<double> getAverageExpenseAmount() async {
    final expenses = await getAllExpenses();
    if (expenses.isEmpty) return 0.0;

    final total = expenses.fold<double>(
        0.0, (double sum, Expense expense) => sum + expense.amount);
    return total / expenses.length;
  }

  Future<List<Expense>> getRecentExpenses({int limit = 10}) async {
    final expenses = await getAllExpenses();
    expenses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return expenses.take(limit).toList();
  }
}
