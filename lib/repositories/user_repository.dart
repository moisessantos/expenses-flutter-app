import 'package:mongo_dart/mongo_dart.dart';
import '../models/user.dart';

abstract class UserRepository {
  Future<List<User>> findAll();
  Future<User?> findById(String id);
  Future<User?> findByName(String name);
  Future<User> create(User user);
}

class MongoUserRepository implements UserRepository {
  final Db _db;
  late final DbCollection _usersCollection;

  MongoUserRepository(this._db) {
    _usersCollection = _db.collection('users');
  }

  @override
  Future<List<User>> findAll() async {
    try {
      final results = await _usersCollection.find().toList();
      return results.map((doc) => User.fromJson(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  @override
  Future<User?> findById(String id) async {
    try {
      final result =
          await _usersCollection.findOne({'_id': ObjectId.fromHexString(id)});
      return result != null ? User.fromJson(result) : null;
    } catch (e) {
      throw Exception('Failed to find user by id: $e');
    }
  }

  @override
  Future<User?> findByName(String name) async {
    try {
      final result = await _usersCollection.findOne({'name': name});
      return result != null ? User.fromJson(result) : null;
    } catch (e) {
      throw Exception('Failed to find user by name: $e');
    }
  }

  @override
  Future<User> create(User user) async {
    try {
      final now = DateTime.now();
      final newUser = user.copyWith(
        id: ObjectId().oid,
        createdAt: now,
        updatedAt: now,
      );
      final doc = newUser.toJson();
      // Defensive: ensure no plaintext password fields are persisted even if
      // someone accidentally included them in the model/document.
      doc.remove('password');
      doc.remove('plainPassword');
      doc.remove('passwordPlain');
      final result = await _usersCollection.insertOne(doc);
      if (result.isSuccess) return newUser;
      throw Exception('Failed to create user');
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }
}
