import 'package:mongo_dart/mongo_dart.dart';
import '../models/expense.dart';
import '../models/expense_type.dart';

// Repositories should not read preferences directly; services pass the userId.
abstract class ExpenseRepository {
  Future<List<Expense>> findAll(String userId);
  Future<List<Expense>> findAllWithTypes(String userId);
  Future<Expense?> findById(String id, String userId);
  Future<List<Expense>> findByExpenseType(String expenseTypeId, String userId);
  Future<int> countByExpenseType(String expenseTypeId, String userId);
  Future<List<Expense>> findByDateRange(
      DateTime startDate, DateTime endDate, String userId);
  Future<Expense> create(Expense expense, String userId);
  Future<Expense> update(Expense expense, String userId);
  Future<bool> delete(String id, String userId);
}

class MongoExpenseRepository implements ExpenseRepository {
  final Db _db;
  late final DbCollection _expenseCollection;
  late final DbCollection _expenseTypeCollection;

  MongoExpenseRepository(this._db) {
    _expenseCollection = _db.collection('expenses');
    _expenseTypeCollection = _db.collection('expense_types');
  }

  @override
  Future<List<Expense>> findAll(String userId) async {
    try {
      final results =
          await _expenseCollection.find({'userId': userId}).toList();
      return results.map((doc) => Expense.fromJson(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch expenses: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllExpenseTypes(String userId) async {
    return await _expenseTypeCollection.find({'userId': userId}).toList();
  }

  @override
  Future<List<Expense>> findAllWithTypes(String userId) async {
    try {
      final expenses = await findAll(userId);
      final expenseTypesDocs = await getAllExpenseTypes(userId);

      final expenseTypeMap = <String, ExpenseType>{};
      for (final typeDoc in expenseTypesDocs) {
        final expenseType = ExpenseType.fromJson(typeDoc);
        if (expenseType.id != null) {
          expenseTypeMap[expenseType.id!] = expenseType;
        }
      }

      return expenses.map((expense) {
        final expenseType = expense.expenseTypeId != null
            ? expenseTypeMap[expense.expenseTypeId!]
            : null;
        return expense.copyWith(expenseType: expenseType);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch expenses with types: $e');
    }
  }

  @override
  Future<Expense?> findById(String id, String userId) async {
    try {
      final result =
          await _expenseCollection.findOne({'_id': id, 'userId': userId});
      return result != null ? Expense.fromJson(result) : null;
    } catch (e) {
      throw Exception('Failed to find expense by id: $e');
    }
  }

  @override
  Future<List<Expense>> findByExpenseType(
      String expenseTypeId, String userId) async {
    try {
      final results = await _expenseCollection
          .find({'expenseTypeId': expenseTypeId, 'userId': userId}).toList();
      return results.map((doc) => Expense.fromJson(doc)).toList();
    } catch (e) {
      throw Exception('Failed to find expenses by type: $e');
    }
  }

  @override
  Future<int> countByExpenseType(String expenseTypeId, String userId) async {
    try {
      final count = await _expenseCollection
          .count({'expenseTypeId': expenseTypeId, 'userId': userId});
      return count;
    } catch (e) {
      throw Exception('Failed to count expenses by type: $e');
    }
  }

  @override
  Future<List<Expense>> findByDateRange(
      DateTime startDate, DateTime endDate, String userId) async {
    try {
      final startIso = startDate.toIso8601String();
      final endIso = endDate.toIso8601String();
      final query = {
        'date': {
          '\$gte': startIso,
          '\$lte': endIso,
        },
        'userId': userId,
      };
      final results = await _expenseCollection.find(query).toList();
      final expenses = results.map((doc) => Expense.fromJson(doc)).toList();

      // Fetch expense types only for this user
      final expenseTypes = await getAllExpenseTypes(userId);
      final expenseTypeMap = <String, ExpenseType>{};
      for (final typeDoc in expenseTypes) {
        final expenseType = ExpenseType.fromJson(typeDoc);
        if (expenseType.id != null) {
          expenseTypeMap[expenseType.id!] = expenseType;
        }
      }

      return expenses.map((expense) {
        final expenseType = expense.expenseTypeId != null
            ? expenseTypeMap[expense.expenseTypeId!]
            : null;
        return expense.copyWith(expenseType: expenseType);
      }).toList();
    } catch (e) {
      throw Exception('Failed to find expenses by date range: $e');
    }
  }

  @override
  Future<Expense> create(Expense expense, String userId) async {
    try {
      final now = DateTime.now();
      final newExpense = expense.copyWith(
        id: ObjectId().oid,
        createdAt: now,
        updatedAt: now,
      );
      final doc = newExpense.toJson();
      doc['userId'] = userId;
      final result = await _expenseCollection.insertOne(doc);
      if (result.isSuccess) {
        return newExpense;
      } else {
        throw Exception('Failed to create expense');
      }
    } catch (e) {
      throw Exception('Failed to create expense: $e');
    }
  }

  @override
  Future<Expense> update(Expense expense, String userId) async {
    try {
      if (expense.id == null) {
        throw Exception('Cannot update expense without ID');
      }
      final updatedExpense = expense.copyWith(
        updatedAt: DateTime.now(),
      );
      final doc = updatedExpense.toJson();
      final result = await _expenseCollection
          .updateOne({'_id': expense.id, 'userId': userId}, {'\$set': doc});
      if (result.isSuccess) {
        return updatedExpense;
      } else {
        throw Exception('Failed to update expense');
      }
    } catch (e) {
      throw Exception('Failed to update expense: $e');
    }
  }

  @override
  Future<bool> delete(String id, String userId) async {
    try {
      final result =
          await _expenseCollection.deleteOne({'_id': id, 'userId': userId});
      return result.isSuccess && result.nRemoved > 0;
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }
}
