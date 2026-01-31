import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../di/dependency_container.dart';
import '../services/expense_type_service.dart';
import '../models/expense_type.dart';
import 'package:expenses_app/constants.dart';
import 'package:expenses_app/l10n/app_localizations.dart';

class ExpenseTypesScreen extends StatefulWidget {
  const ExpenseTypesScreen({super.key});

  @override
  State<ExpenseTypesScreen> createState() => _ExpenseTypesScreenState();
}

class _ExpenseTypesScreenState extends State<ExpenseTypesScreen> {
  late final ExpenseTypeService _expenseTypeService;
  List<ExpenseType> _expenseTypes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _expenseTypeService = DependencyContainer().expenseTypeService;
    _loadExpenseTypes();
  }

  Future<void> _loadExpenseTypes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final expenseTypes = await _expenseTypeService.getAllExpenseTypes();
      setState(() {
        _expenseTypes = expenseTypes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading expense types: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteExpenseType(ExpenseType expenseType) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.deleteExpenseType ??
            'Delete Expense Type'),
        content: Text(
          AppLocalizations.of(context)
                  ?.deleteExpenseTypeConfirm(expenseType.name) ??
              'Are you sure you want to delete "${expenseType.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)?.delete ?? 'Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await _expenseTypeService.deleteExpenseType(expenseType.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)
                      ?.expenseTypeDeleted(expenseType.name) ??
                  '${expenseType.name} deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
        _loadExpenseTypes();
      } catch (e) {
        if (mounted) {
          // Check if it's an ArgumentError about expense type being in use
          String errorMessage;
          if (e is ArgumentError &&
              e.message
                  .toString()
                  .contains('Cannot delete expense type that is being used')) {
            // Extract the count from the error message
            final match =
                RegExp(r'(\d+) expense').firstMatch(e.message.toString());
            if (match != null) {
              final count = int.parse(match.group(1)!);
              errorMessage = AppLocalizations.of(context)
                      ?.cannotDeleteExpenseTypeInUse(count) ??
                  'Cannot delete this expense type because it is being used by $count expense(s)';
            } else {
              errorMessage = AppLocalizations.of(context)
                      ?.errorDeletingExpenseType(e.toString()) ??
                  'Error deleting expense type: $e';
            }
          } else {
            errorMessage = AppLocalizations.of(context)
                    ?.errorDeletingExpenseType(e.toString()) ??
                'Error deleting expense type: $e';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }

  Color _parseColor(String colorHex) {
    try {
      final hex = colorHex.startsWith('#') ? colorHex.substring(1) : colorHex;
      return Color(int.parse('0xFF$hex'));
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context)?.expenseTypesTitle ?? 'Expense Types'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _expenseTypes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.category,
                        size: kAvatarSize64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: kPadding16),
                      Text(
                        AppLocalizations.of(context)?.noExpenseTypesYet ??
                            'No expense types yet',
                        style: const TextStyle(
                          fontSize: kLargeFontSize,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: kPadding16),
                      ElevatedButton(
                        onPressed: () => context.go('/add-expense-type'),
                        child: Text(
                            AppLocalizations.of(context)?.addFirstType ??
                                'Add Your First Type'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadExpenseTypes,
                  child: ListView.builder(
                    itemCount: _expenseTypes.length,
                    padding: const EdgeInsets.all(kPadding16),
                    itemBuilder: (context, index) {
                      final expenseType = _expenseTypes[index];
                      final color = _parseColor(expenseType.color);

                      return Card(
                        margin: const EdgeInsets.only(bottom: kPadding12),
                        child: ListTile(
                          onTap: () async {
                            await context
                                .push('/update-expense-type/${expenseType.id}');
                            _loadExpenseTypes();
                          },
                          leading: CircleAvatar(
                            backgroundColor: color,
                            child: Icon(
                              Icons.category,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            expenseType.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(expenseType.description),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'delete') {
                                _deleteExpenseType(expenseType);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/add-expense-type');
          _loadExpenseTypes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
