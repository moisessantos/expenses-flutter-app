import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../config/env.dart';
import '../repositories/expense_repository.dart';
import '../repositories/expense_type_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/preferences_repository.dart';
import '../services/preferences_service.dart';
import '../services/expense_service.dart';
import '../services/expense_type_service.dart';
import '../services/user_service.dart';

class DependencyContainer {
  static final DependencyContainer _instance = DependencyContainer._internal();

  factory DependencyContainer() {
    return _instance;
  }

  DependencyContainer._internal();

  // Database
  mongo.Db? _db;

  // Repositories
  ExpenseRepository? _expenseRepository;
  ExpenseTypeRepository? _expenseTypeRepository;
  // User repository
  UserRepository? _userRepository;

  // Services
  ExpenseService? _expenseService;
  ExpenseTypeService? _expenseTypeService;
  // User service
  UserService? _userService;

  // Initialize the database connection
  Future<void> initialize() async {
    if (_db == null || _db!.state != mongo.State.open) {
      try {
        debugPrint('Attempting to connect to MongoDB...');
        _db = await mongo.Db.create(_connectionString);

        // Set connection timeout
        await _db!.open().timeout(
          const Duration(seconds: 30Env.mongoDbC
          onTimeout: () {
            throw Exception(
              'MongoDB connection timeout. Please check your internet connection.',
            );
          },
        );

        debugPrint('Database connected successfully');
      } catch (e) {
        debugPrint('MongoDB connection error: $e');
        rethrow;
      }
    }
    // Load persisted locale (if any)
    try {
      final saved = await preferencesRepository.loadLocale();
      if (saved != null) {
        localeNotifier.value = saved;
      }
    } catch (e) {
      // Ignore preferences load errors - app can continue with default locale
      debugPrint('Could not load saved locale: $e');
    }
  }

  // Close database connection
  Future<void> close() async {
    if (_db != null && _db!.state == mongo.State.open) {
      await _db!.close();
      debugPrint('Database connection closed');
    }
  }

  // Reconnect to database if connection was lost
  Future<void> ensureConnection() async {
    if (_db == null || _db!.state != mongo.State.open) {
      debugPrint('Database connection lost, reconnecting...');
      _db = null; // Clear the old instance
      await initialize(); // Reinitialize connection
    }
  }

  // Get database instance with automatic reconnection
  Future<mongo.Db> getDb() async {
    await ensureConnection();
    return _db!;
  }

  // Synchronous getter for backward compatibility (use with caution)
  mongo.Db get db {
    if (_db == null || _db!.state != mongo.State.open) {
      throw StateError('Database not initialized. Call initialize() first.');
    }
    return _db!;
  }

  // Get repositories
  ExpenseRepository get expenseRepository {
    _expenseRepository ??= MongoExpenseRepository(db);
    return _expenseRepository!;
  }

  ExpenseTypeRepository get expenseTypeRepository {
    _expenseTypeRepository ??= MongoExpenseTypeRepository(db);
    return _expenseTypeRepository!;
  }

  UserRepository get userRepository {
    _userRepository ??= MongoUserRepository(db);
    return _userRepository!;
  }

  // Get services
  ExpenseService get expenseService {
    _expenseService ??= ExpenseService(
        expenseRepository, expenseTypeRepository, preferencesRepository);
    return _expenseService!;
  }

  ExpenseTypeService get expenseTypeService {
    _expenseTypeService ??=
        ExpenseTypeService(expenseTypeRepository, expenseRepository);
    return _expenseTypeService!;
  }

  UserService get userService {
    _userService ??= UserService(userRepository);
    return _userService!;
  }

  // Reset all instances (useful for testing)
  void reset() {
    _expenseRepository = null;
    _expenseTypeRepository = null;
    _expenseService = null;
    _expenseTypeService = null;
    _userRepository = null;
    _userService = null;
    // Note: We don't reset _db here to avoid connection issues
  }

  // Locale notifier for simple in-app language switching
  final ValueNotifier<Locale?> localeNotifier = ValueNotifier<Locale?>(null);

  // Preferences repository (persisted settings)
  PreferencesRepository? _preferencesRepository;

  PreferencesRepository get preferencesRepository {
    _preferencesRepository ??= PreferencesRepository();
    return _preferencesRepository!;
  }

  // Preferences service
  PreferencesService? _preferencesService;

  PreferencesService get preferencesService {
    _preferencesService ??= PreferencesService(preferencesRepository);
    return _preferencesService!;
  }
}
