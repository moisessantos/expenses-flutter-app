import 'package:expenses_app/widgets/small_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../di/dependency_container.dart';
import '../services/expense_service.dart';
import '../models/expense.dart';
import 'package:expenses_app/l10n/app_localizations.dart';
import 'package:expenses_app/constants.dart';
import '../widgets/category_filter_widget.dart';
import '../widgets/date_filter_widget.dart';
import '../widgets/view_expenses_parts.dart';
import '../widgets/filter_icon.dart';

class ViewExpensesScreen extends StatefulWidget {
  const ViewExpensesScreen({super.key});

  @override
  State<ViewExpensesScreen> createState() => _ViewExpensesScreenState();
}

class _ViewExpensesScreenState extends State<ViewExpensesScreen> {
  // ChartLegend is provided via widgets/view_expenses_parts.dart

  // Parse hex color from expense type or return a theme-aware fallback
  Color _colorFromHexOrFallback(String? hex) {
    final fallback = Theme.of(context).colorScheme.surfaceContainerHighest;
    if (hex == null) return fallback;
    try {
      final cleaned = hex.startsWith('#') ? hex.substring(1) : hex;
      return Color(int.parse('0xFF$cleaned'));
    } catch (_) {
      return fallback;
    }
  }

  List<Expense> _filteredExpenses = [];
  bool _isLoading = true;
  String _sortBy = 'date'; // 'date', 'amount', 'title'
  bool _sortDescending = true;
  bool _showFilters = false; // Toggle for showing/hiding filters

  // Date filtering
  DateTime? _startDate;
  DateTime? _endDate;
  String _dateFilter = 'all'; // 'all', 'week', 'month', 'custom'

  // Category filtering
  List<String> _selectedCategories = [];
  List<String> _allCategories = [];
  bool _categoriesLoading = false;

  late final ExpenseService _expenseService;

  @override
  void initState() {
    super.initState();
    _expenseService = DependencyContainer().expenseService;
    _loadExpenses();
    _fetchCategories();
    _loadSavedFilters();
  }

  Future<void> _loadSavedFilters() async {
    try {
      final filters =
          await DependencyContainer().preferencesService.loadViewFilters();
      if (filters != null) {
        setState(() {
          _dateFilter = filters.dateFilter;
          _startDate = filters.startDate;
          _endDate = filters.endDate;
          _selectedCategories = List.from(filters.selectedCategories);
        });
        // Reload expenses with the restored filters
        await _loadExpenses();
      }
    } catch (e) {
      // ignore errors - proceed with defaults
    }
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _categoriesLoading = true;
    });
    try {
      final expenseTypeService = DependencyContainer().expenseTypeService;
      final types = await expenseTypeService.getAllExpenseTypes();
      setState(() {
        _allCategories = types.map((e) => e.name).toList();
        _categoriesLoading = false;
      });
    } catch (e) {
      setState(() {
        _categoriesLoading = false;
      });
    }
  }

  // Category selection is handled by CategoryFilterWidget via callbacks

  List<Expense> get _categoryFilteredExpenses {
    if (_selectedCategories.isEmpty) return _filteredExpenses;
    return _filteredExpenses
        .where((e) =>
            e.expenseType != null &&
            _selectedCategories.contains(e.expenseType!.name))
        .toList();
  }

  Future<void> _loadExpenses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Expense> expenses;

      if (_startDate != null && _endDate != null) {
        expenses = await _expenseService.getExpensesByDateRange(
            _startDate!, _endDate!);
      } else {
        expenses = await _expenseService.getAllExpenses();
      }

      setState(() {
        _filteredExpenses = expenses;
        _sortExpenses();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                    ?.errorLoadingExpenses(e.toString()) ??
                'Error loading expenses: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _sortExpenses() {
    _filteredExpenses.sort((a, b) {
      int comparison = 0;

      switch (_sortBy) {
        case 'date':
          comparison = a.date.compareTo(b.date);
          break;
        case 'amount':
          comparison = a.amount.compareTo(b.amount);
          break;
        case 'title':
          comparison = a.title.compareTo(b.title);
          break;
      }

      return _sortDescending ? -comparison : comparison;
    });
  }

  void _changeSorting(String sortBy) {
    setState(() {
      if (_sortBy == sortBy) {
        _sortDescending = !_sortDescending;
      } else {
        _sortBy = sortBy;
        _sortDescending = true;
      }
      _sortExpenses();
    });
  }

  // Date filters are handled by DateFilterWidget

  void _saveFilters() {
    try {
      DependencyContainer().preferencesService.saveViewFilters(
            dateFilter: _dateFilter,
            startDate: _startDate,
            endDate: _endDate,
            selectedCategories: _selectedCategories,
          );
    } catch (e) {
      // ignore errors during save
    }
  }

  // Chart area replaced by BarChartArea

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters =
        _dateFilter != 'all' || _selectedCategories.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.appTitle ?? 'All Expenses'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          // Filter toggle button
          IconButton(
            icon: FilterIcon(
              isActive: hasActiveFilters,
              size: 24.0,
            ),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            tooltip: 'Toggle Filters',
          ),
          PopupMenuButton<String>(
            onSelected: _changeSorting,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'date',
                child: Row(
                  children: [
                    Icon(
                        _sortBy == 'date' ? Icons.check : Icons.calendar_today),
                    const SmallSpacing(),
                    Text(AppLocalizations.of(context)?.sortByDate ??
                        'Sort by Date'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'amount',
                child: Row(
                  children: [
                    Icon(
                        _sortBy == 'amount' ? Icons.check : Icons.attach_money),
                    const SmallSpacing(),
                    Text(AppLocalizations.of(context)?.sortByAmount ??
                        'Sort by Amount'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'title',
                child: Row(
                  children: [
                    Icon(_sortBy == 'title' ? Icons.check : Icons.title),
                    const SmallSpacing(),
                    Text(AppLocalizations.of(context)?.sortByTitle ??
                        'Sort by Title'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Animated collapsible filter section
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _showFilters ? null : 0,
                  curve: Curves.easeInOut,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        DateFilterWidget(
                          dateFilter: _dateFilter,
                          startDate: _startDate,
                          endDate: _endDate,
                          onChanged: (filter, start, end) async {
                            setState(() {
                              _dateFilter = filter;
                              _startDate = start;
                              _endDate = end;
                            });
                            await _loadExpenses();
                            _saveFilters();
                          },
                        ),
                        CategoryFilterWidget(
                          allCategories: _allCategories,
                          selectedCategories: _selectedCategories,
                          loading: _categoriesLoading,
                          onToggle: (next) {
                            setState(() {
                              _selectedCategories = next;
                            });
                            _loadExpenses();
                            _saveFilters();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                if (_categoryFilteredExpenses.isNotEmpty) ...[
                  Container(
                    padding: kScreenPadding,
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .totalExpenses(_categoryFilteredExpenses.length),
                          style: const TextStyle(
                            fontSize: kMediumFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.totalAmount(
                              _categoryFilteredExpenses
                                  .fold<double>(0.0, (sum, e) => sum + e.amount)
                                  .toStringAsFixed(2)),
                          style: const TextStyle(
                            fontSize: kMediumFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: kPadding16, vertical: kPadding8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kPadding12, vertical: kPadding8),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(child: SizedBox()),
                              ChartLegend(
                                  expenses: _categoryFilteredExpenses,
                                  colorFromHexOrFallback:
                                      _colorFromHexOrFallback),
                            ],
                          ),
                          const SizedBox(height: kPadding4),
                          BarChartArea(
                              expenses: _categoryFilteredExpenses,
                              dateFilter: _dateFilter,
                              colorFromHexOrFallback: _colorFromHexOrFallback),
                        ],
                      ),
                    ),
                  ),
                ],
                Expanded(
                  child: _categoryFilteredExpenses.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.receipt_long,
                                size: kAvatarSize64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: kPadding16),
                              Text(
                                _dateFilter == 'all'
                                    ? (AppLocalizations.of(context)
                                            ?.noExpenses ??
                                        'No expenses found')
                                    : (AppLocalizations.of(context)
                                            ?.noExpensesPeriod ??
                                        'No expenses found for selected period'),
                                style: const TextStyle(
                                  fontSize: kLargeFontSize,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: kPadding16),
                              ElevatedButton(
                                onPressed: () => context.go('/add-expense'),
                                child: Text(AppLocalizations.of(context)
                                        ?.addFirstExpense ??
                                    'Add Your First Expense'),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadExpenses,
                          child: ListView.builder(
                            itemCount: _categoryFilteredExpenses.length,
                            itemBuilder: (context, index) {
                              final expense = _categoryFilteredExpenses[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: kPadding16,
                                  vertical: 4.0,
                                ),
                                child: ListTile(
                                  onTap: () => context
                                      .go('/update-expense/${expense.id!}'),
                                  leading: CircleAvatar(
                                    backgroundColor: expense.expenseType != null
                                        ? Color(int.parse(
                                            '0xFF${expense.expenseType!.color.substring(1)}'))
                                        : Colors.grey,
                                    child: Text(
                                      '${expense.amount.toStringAsFixed(0)}€',
                                      style: const TextStyle(
                                        color: kAvatarTextColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    expense.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(expense.description ?? ''),
                                      const SizedBox(height: kPadding4),
                                      Row(
                                        children: [
                                          if (expense.expenseType != null) ...[
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color(int.parse(
                                                    '0xFF${expense.expenseType!.color.substring(1)}')),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                expense.expenseType!.name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: kSmallFontSize,
                                                ),
                                              ),
                                            ),
                                            const SmallSpacing(),
                                          ],
                                          Text(
                                            '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: kSmallFontSize,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    '${expense.amount.toStringAsFixed(2)}€',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: kMediumFontSize,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add-expense'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
