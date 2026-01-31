import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';

class UserService {
  final UserRepository _userRepository;

  UserService(this._userRepository);

  Future<List<User>> getAllUsers() async {
    return await _userRepository.findAll();
  }

  Future<User?> getUserById(String id) async {
    return await _userRepository.findById(id);
  }

  /// Create a user with a salted password. The password is hashed using HMAC-SHA256
  /// with a per-user random salt. Returns the created user.
  Future<User> createUser(
      {required String name, required String password}) async {
    if (name.trim().isEmpty) throw ArgumentError('Name cannot be empty');
    if (password.isEmpty) throw ArgumentError('Password cannot be empty');

    final existing = await _userRepository.findByName(name.trim());
    if (existing != null) {
      throw ArgumentError('User with this name already exists');
    }

    final now = DateTime.now();
    // generate a random salt
    final saltBytes = _generateSalt();
    final salt = base64UrlEncode(saltBytes);
    final passwordHash = _hashPassword(password, saltBytes);

    final user = User(
      name: name.trim(),
      salt: salt,
      passwordHash: passwordHash,
      createdAt: now,
      updatedAt: now,
    );

    final created = await _userRepository.create(user);
    return created;
  }

  /// Authenticate a user by name and password. Returns the user if authentication
  /// succeeds, otherwise returns null.
  Future<User?> getUser(String name, String password) async {
    final user = await _userRepository.findByName(name.trim());
    if (user == null) return null;
    final saltBytes = base64Url.decode(user.salt);
    final hash = _hashPassword(password, saltBytes);
    if (hash == user.passwordHash) return user;
    return null;
  }

  List<int> _generateSalt([int length = 16]) {
    // Use a cryptographically secure RNG for salt generation.
    final secure = Random.secure();
    return List<int>.generate(length, (_) => secure.nextInt(256));
  }

  String _hashPassword(String password, List<int> saltBytes) {
    final key = utf8.encode(password);
    final bytes = <int>[...saltBytes, ...key];
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes);
  }
}
