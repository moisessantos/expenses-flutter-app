import 'package:flutter/material.dart';
import '../repositories/preferences_repository.dart';

class PreferencesService {
  final PreferencesRepository _repo;

  PreferencesService(this._repo);

  Future<void> saveLocale(Locale locale) => _repo.saveLocale(locale);

  Future<Locale?> loadLocale() => _repo.loadLocale();

  Future<void> saveViewFilters({
    required String dateFilter,
    DateTime? startDate,
    DateTime? endDate,
    required List<String> selectedCategories,
  }) {
    return _repo.saveViewFilters(
      dateFilter: dateFilter,
      startDate: startDate,
      endDate: endDate,
      selectedCategories: selectedCategories,
    );
  }

  Future<ViewFilters?> loadViewFilters() async {
    final map = await _repo.loadViewFilters();
    if (map == null) return null;
    final dateFilter = map['dateFilter'] as String? ?? 'all';
    final startIso = map['startDate'] as String?;
    final endIso = map['endDate'] as String?;
    final startDate = startIso != null ? DateTime.parse(startIso) : null;
    final endDate = endIso != null ? DateTime.parse(endIso) : null;
    final selected = (map['selectedCategories'] as List?)?.cast<String>() ?? [];
    return ViewFilters(
      dateFilter: dateFilter,
      startDate: startDate,
      endDate: endDate,
      selectedCategories: selected,
    );
  }

  // --- User id helpers ---
  Future<void> saveUserId(String userId) async {
    return _repo.saveUserId(userId);
  }

  Future<String?> loadUserId() async {
    return _repo.loadUserId();
  }
}

class ViewFilters {
  final String dateFilter;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> selectedCategories;

  ViewFilters({
    required this.dateFilter,
    this.startDate,
    this.endDate,
    required this.selectedCategories,
  });
}
