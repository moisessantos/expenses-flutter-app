import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:expenses_app/models/expense_type.dart';
import 'package:expenses_app/models/expense.dart';
import 'package:expenses_app/services/expense_service.dart';
import 'package:expenses_app/repositories/expense_repository.dart';
import 'package:expenses_app/repositories/expense_type_repository.dart';
import 'package:expenses_app/repositories/preferences_repository.dart';

class SimpleFakePreferencesRepository extends PreferencesRepository {
  String? _userId = 'test-user-id';

  @override
  Future<String?> loadUserId() async => _userId;

  @override
  Future<void> saveUserId(String userId) async {
    _userId = userId;
  }
}

class SimpleFakeExpenseRepository implements ExpenseRepository {
  final List<Expense> _data = [];

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
          DateTime startDate, DateTime endDate, String userId) async =>
      _data
          .where((e) => !e.date.isBefore(startDate) && !e.date.isAfter(endDate))
          .toList();

  int createCalls = 0;
  @override
  Future<Expense> create(Expense expense, String userId) async {
    createCalls++;
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

class SimpleFakeExpenseTypeRepository implements ExpenseTypeRepository {
  @override
  Future<List<ExpenseType>> findAll(String userId) async => [];

  @override
  Future<ExpenseType> create(ExpenseType expenseType, String userId) async =>
      throw UnimplementedError();

  @override
  Future<ExpenseType> update(ExpenseType expenseType, String userId) async =>
      throw UnimplementedError();

  @override
  Future<bool> delete(String id, String userId) async =>
      throw UnimplementedError();

  @override
  Future<ExpenseType?> findById(String id, String userId) async {
    return null;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock path_provider for tests
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (MethodCall methodCall) async {
    if (methodCall.method == 'getApplicationDocumentsDirectory') {
      return '/tmp';
    }
    return null;
  });

  test(
      'ExpenseService accepts accented and special characters in title/description',
      () async {
    final repo = SimpleFakeExpenseRepository();
    final prefsRepo = SimpleFakePreferencesRepository();
    final service =
        ExpenseService(repo, SimpleFakeExpenseTypeRepository(), prefsRepo);

    final title = "Café, João´s `quote` ^caret ~tilde çcedilla";
    final description =
        "Description with accents: á, é, í, ó, ú, ç, ñ, ` ^ ~ ´";

    final created = await service.createExpense(
      title: title,
      description: description,
      amount: 12.34,
      date: DateTime.now(),
      expenseTypeId: 'test-expense-type-id',
    );

    expect(repo.createCalls, equals(1));
    expect(created.title, equals(title.trim()));
    expect(created.description, equals(description.trim()));
  });
}
