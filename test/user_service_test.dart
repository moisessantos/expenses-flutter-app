import 'package:flutter_test/flutter_test.dart';
import 'package:expenses_app/models/user.dart';
import 'package:expenses_app/repositories/user_repository.dart';
import 'package:expenses_app/services/user_service.dart';

class FakeUserRepository implements UserRepository {
  final List<User> _store = [];
  int _idCounter = 0;

  @override
  Future<User> create(User user) async {
    final now = DateTime.now();
    final newUser = user.copyWith(
      id: user.id ?? 'test-user-id-${_idCounter++}',
      createdAt: now,
      updatedAt: now,
    );
    _store.add(newUser);
    return newUser;
  }

  @override
  Future<List<User>> findAll() async => List.unmodifiable(_store);

  @override
  Future<User?> findById(String id) async {
    try {
      return _store.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<User?> findByName(String name) async {
    try {
      return _store.firstWhere((u) => u.name == name);
    } catch (_) {
      return null;
    }
  }
}

void main() {
  late FakeUserRepository repo;
  late UserService service;

  setUp(() {
    repo = FakeUserRepository();
    service = UserService(repo);
  });

  test('createUser produces salt and passwordHash and stores user', () async {
    final created = await service.createUser(name: 'alice', password: 's3cr3t');

    expect(created.name, 'alice');
    expect(created.salt.isNotEmpty, isTrue);
    expect(created.passwordHash.isNotEmpty, isTrue);

    final stored = await repo.findByName('alice');
    expect(stored, isNotNull);
    expect(stored!.salt, created.salt);
    expect(stored.passwordHash, created.passwordHash);
  });

  test('getUser authenticates with correct password and rejects wrong one',
      () async {
    await service.createUser(name: 'bob', password: 'hunter2');

    final ok = await service.getUser('bob', 'hunter2');
    expect(ok, isNotNull);
    expect(ok!.name, 'bob');

    final bad = await service.getUser('bob', 'nope');
    expect(bad, isNull);
  });

  test('createUser throws on duplicate name', () async {
    await service.createUser(name: 'chris', password: 'pw');
    expect(() => service.createUser(name: 'chris', password: 'other'),
        throwsArgumentError);
  });

  test('different users with same password have different salts and hashes',
      () async {
    final a = await service.createUser(name: 'u1', password: 'samepw');
    final b = await service.createUser(name: 'u2', password: 'samepw');

    expect(a.salt, isNot(equals(b.salt)));
    expect(a.passwordHash, isNot(equals(b.passwordHash)));
  });
}
