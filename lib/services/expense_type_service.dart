import '../models/expense_type.dart';
import '../repositories/expense_type_repository.dart';
import '../repositories/expense_repository.dart';
import '../di/dependency_container.dart';

class ExpenseTypeService {
  final ExpenseTypeRepository _repository;
  final ExpenseRepository _expenseRepository;

  ExpenseTypeService(this._repository, this._expenseRepository);

  Future<List<ExpenseType>> getAllExpenseTypes() async {
    final savedUserId =
        await DependencyContainer().preferencesService.loadUserId();
    if (savedUserId == null) return [];
    return await _repository.findAll(savedUserId);
  }

  Future<ExpenseType?> getExpenseTypeById(String id) async {
    final savedUserId =
        await DependencyContainer().preferencesService.loadUserId();
    if (savedUserId == null) return null;
    return await _repository.findById(id, savedUserId);
  }

  Future<ExpenseType> createExpenseType({
    required String name,
    required String description,
    required String color,
  }) async {
    // Validate inputs
    if (name.trim().isEmpty) {
      throw ArgumentError('Expense type name cannot be empty');
    }
    if (description.trim().isEmpty) {
      throw ArgumentError('Expense type description cannot be empty');
    }
    if (color.trim().isEmpty) {
      throw ArgumentError('Expense type color cannot be empty');
    }

    final savedUserId =
        await DependencyContainer().preferencesService.loadUserId();
    if (savedUserId == null) throw Exception('No authenticated user');

    // Check if expense type with same name already exists for this user
    final existingTypes = await _repository.findAll(savedUserId);
    final duplicateName = existingTypes.any(
      (type) => type.name.toLowerCase() == name.toLowerCase(),
    );

    if (duplicateName) {
      throw ArgumentError('An expense type with this name already exists');
    }

    final now = DateTime.now();
    final expenseType = ExpenseType(
      name: name.trim(),
      description: description.trim(),
      color: color.trim(),
      createdAt: now,
      updatedAt: now,
    );

    return await _repository.create(expenseType, savedUserId);
  }

  Future<ExpenseType> updateExpenseType(ExpenseType expenseType) async {
    if (expenseType.id == null) {
      throw ArgumentError('Cannot update expense type without ID');
    }

    // Validate inputs
    if (expenseType.name.trim().isEmpty) {
      throw ArgumentError('Expense type name cannot be empty');
    }
    if (expenseType.description.trim().isEmpty) {
      throw ArgumentError('Expense type description cannot be empty');
    }
    if (expenseType.color.trim().isEmpty) {
      throw ArgumentError('Expense type color cannot be empty');
    }

    final savedUserId =
        await DependencyContainer().preferencesService.loadUserId();
    if (savedUserId == null) throw Exception('No authenticated user');

    // Check if another expense type with same name already exists for this user
    final existingTypes = await _repository.findAll(savedUserId);
    final duplicateName = existingTypes.any(
      (type) =>
          type.id != expenseType.id &&
          type.name.toLowerCase() == expenseType.name.toLowerCase(),
    );

    if (duplicateName) {
      throw ArgumentError('Another expense type with this name already exists');
    }

    final updatedExpenseType = expenseType.copyWith(
      name: expenseType.name.trim(),
      description: expenseType.description.trim(),
      color: expenseType.color.trim(),
    );

    return await _repository.update(updatedExpenseType, savedUserId);
  }

  Future<bool> deleteExpenseType(String id) async {
    final savedUserId =
        await DependencyContainer().preferencesService.loadUserId();
    if (savedUserId == null) return false;

    // Check if there are expenses using this type
    final expenseCount =
        await _expenseRepository.countByExpenseType(id, savedUserId);
    if (expenseCount > 0) {
      throw ArgumentError(
          'Cannot delete expense type that is being used by $expenseCount expense(s)');
    }

    return await _repository.delete(id, savedUserId);
  }

  Future<bool> canDeleteExpenseType(String id) async {
    final savedUserId =
        await DependencyContainer().preferencesService.loadUserId();
    if (savedUserId == null) return false;

    final expenseCount =
        await _expenseRepository.countByExpenseType(id, savedUserId);
    return expenseCount == 0;
  }
}
