import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class PreferencesRepository {
  static const _localeKey = 'selected_locale';
  static const _prefsTable = 'app_preferences';
  static const _prefsKey = 'prefs_key';

  Database? _db;

  Future<Database> _getDb() async {
    if (_db != null) return _db!;
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = p.join(documentsDirectory.path, 'expenses_app.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_prefsTable (
            $_prefsKey TEXT PRIMARY KEY,
            value TEXT
          )
        ''');
      },
    );
    return _db!;
  }

  Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  Future<Locale?> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey);
    if (code == null) return null;
    return Locale(code);
  }

  // --- View filters persistence using sqlite ---
  // We'll store a single JSON object under key 'view_filters'
  static const _viewFiltersKey = 'view_filters';
  // Key used to store the authenticated user's id
  static const _userIdKey = 'user_id';

  Future<void> saveViewFilters({
    required String dateFilter,
    DateTime? startDate,
    DateTime? endDate,
    required List<String> selectedCategories,
  }) async {
    final db = await _getDb();
    final map = {
      'dateFilter': dateFilter,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'selectedCategories': selectedCategories,
    };
    final jsonStr = jsonEncode(map);
    await db.insert(_prefsTable, {_prefsKey: _viewFiltersKey, 'value': jsonStr},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> loadViewFilters() async {
    final db = await _getDb();
    final rows = await db.query(_prefsTable,
        columns: ['value'],
        where: '$_prefsKey = ?',
        whereArgs: [_viewFiltersKey]);
    if (rows.isEmpty) return null;
    final jsonStr = rows.first['value'] as String?;
    if (jsonStr == null) return null;
    final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
    return decoded;
  }

  // --- User id persistence ---
  Future<void> saveUserId(String userId) async {
    final db = await _getDb();
    final map = {'userId': userId};
    final jsonStr = jsonEncode(map);
    await db.insert(_prefsTable, {_prefsKey: _userIdKey, 'value': jsonStr},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> loadUserId() async {
    final db = await _getDb();
    final rows = await db.query(_prefsTable,
        columns: ['value'], where: '$_prefsKey = ?', whereArgs: [_userIdKey]);
    if (rows.isEmpty) return null;
    final jsonStr = rows.first['value'] as String?;
    if (jsonStr == null) return null;
    final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
    return decoded['userId'] as String?;
  }
}
