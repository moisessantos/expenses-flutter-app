import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:expenses_app/repositories/preferences_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PreferencesRepository', () {
    late PreferencesRepository repo;

    setUp(() {
      repo = PreferencesRepository();
      // Start with empty in-memory prefs for each test
      SharedPreferences.setMockInitialValues({});
    });

    test('loadLocale returns null when no locale saved', () async {
      final loaded = await repo.loadLocale();
      expect(loaded, isNull);
    });

    test('saveLocale then loadLocale returns same language code', () async {
      final locale = const Locale('pt');
      await repo.saveLocale(locale);
      final loaded = await repo.loadLocale();
      expect(loaded, isNotNull);
      expect(loaded!.languageCode, equals(locale.languageCode));
    });
  });
}
