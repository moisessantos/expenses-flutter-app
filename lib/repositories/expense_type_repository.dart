import 'package:mongo_dart/mongo_dart.dart';
import '../models/expense_type.dart';

abstract class ExpenseTypeRepository {
  Future<List<ExpenseType>> findAll(String userId);
  Future<ExpenseType?> findById(String id, String userId);
  Future<ExpenseType> create(ExpenseType expenseType, String userId);
  Future<ExpenseType> update(ExpenseType expenseType, String userId);
  Future<bool> delete(String id, String userId);
}

class MongoExpenseTypeRepository implements ExpenseTypeRepository {
  final Db _db;
  late final DbCollection _collection;

  MongoExpenseTypeRepository(this._db) {
    _collection = _db.collection('expense_types');
  }

  @override
  Future<List<ExpenseType>> findAll(String userId) async {
    try {
      final query = {'userId': userId};
      final results = await _collection.find(query).toList();
      return results.map((doc) => ExpenseType.fromJson(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch expense types: $e');
    }
  }

  @override
  Future<ExpenseType?> findById(String id, String userId) async {
    try {
      final query = {'_id': id, 'userId': userId};
      final result = await _collection.findOne(query);
      return result != null ? ExpenseType.fromJson(result) : null;
    } catch (e) {
      throw Exception('Failed to find expense type by id: $e');
    }
  }

  @override
  Future<ExpenseType> create(ExpenseType expenseType, String userId) async {
    try {
      final now = DateTime.now();
      final newExpenseType = expenseType.copyWith(
        id: ObjectId().oid,
        createdAt: now,
        updatedAt: now,
      );

      final doc = newExpenseType.toJson();
      doc['userId'] = userId;
      final result = await _collection.insertOne(doc);

      if (result.isSuccess) {
        return newExpenseType;
      } else {
        throw Exception('Failed to create expense type');
      }
    } catch (e) {
      throw Exception('Failed to create expense type: $e');
    }
  }

  @override
  Future<ExpenseType> update(ExpenseType expenseType, String userId) async {
    try {
      if (expenseType.id == null) {
        throw Exception('Cannot update expense type without ID');
      }

      final updatedExpenseType = expenseType.copyWith(
        updatedAt: DateTime.now(),
      );

      final doc = updatedExpenseType.toJson();
      final filter = {'_id': expenseType.id, 'userId': userId};
      final result = await _collection.updateOne(filter, {'\$set': doc});

      if (result.isSuccess) {
        return updatedExpenseType;
      } else {
        throw Exception('Failed to update expense type');
      }
    } catch (e) {
      throw Exception('Failed to update expense type: $e');
    }
  }

  @override
  Future<bool> delete(String id, String userId) async {
    try {
      final filter = {'_id': id, 'userId': userId};
      final result = await _collection.deleteOne(filter);
      return result.isSuccess && result.nRemoved > 0;
    } catch (e) {
      throw Exception('Failed to delete expense type: $e');
    }
  }
}
