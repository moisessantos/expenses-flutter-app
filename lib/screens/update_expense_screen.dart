import 'package:expenses_app/widgets/large_spacing.dart';
import 'package:expenses_app/widgets/medium_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../di/dependency_container.dart';
import '../services/expense_service.dart';
import '../services/expense_type_service.dart';
import '../models/expense_type.dart';
import '../models/expense.dart';
import 'package:expenses_app/l10n/app_localizations.dart';
import '../widgets/add_expense_parts.dart';
import '../widgets/app_button.dart';
import 'package:expenses_app/constants.dart';

class UpdateExpenseScreen extends StatefulWidget {
  final String expenseId;

  const UpdateExpenseScreen({super.key, required this.expenseId});

  @override
  State<UpdateExpenseScreen> createState() => _UpdateExpenseScreenState();
}

class _UpdateExpenseScreenState extends State<UpdateExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  ExpenseType? _selectedExpenseType;
  List<ExpenseType> _expenseTypes = [];
  bool _isLoading = false;
  bool _isLoadingTypes = true;
  bool _isLoadingExpense = true;
  Expense? _expense;

  late final ExpenseService _expenseService;
  late final ExpenseTypeService _expenseTypeService;

  @override
  void initState() {
    super.initState();
    _expenseService = DependencyContainer().expenseService;
    _expenseTypeService = DependencyContainer().expenseTypeService;
    _loadExpenseTypes();
    _loadExpense();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadExpense() async {
    try {
      final expense = await _expenseService.getExpenseById(widget.expenseId);

      if (expense == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Expense not found'),
              backgroundColor: Colors.red,
            ),
          );
          context.go('/view-expenses');
        }
        return;
      }

      setState(() {
        _expense = expense;
        _titleController.text = expense.title;
        _descriptionController.text = expense.description ?? '';
        _amountController.text = expense.amount.toString();
        _selectedDate = expense.date;
        _isLoadingExpense = false;
      });

      // Set selected expense type once types are loaded
      if (_expenseTypes.isNotEmpty && expense.expenseTypeId != null) {
        setState(() {
          _selectedExpenseType = _expenseTypes.firstWhere(
            (type) => type.id == expense.expenseTypeId,
            orElse: () => _expenseTypes.first,
          );
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingExpense = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading expense: $e'),
            backgroundColor: Colors.red,
          ),
        );
        context.go('/view-expenses');
      }
    }
  }

  Future<void> _loadExpenseTypes() async {
    try {
      final types = await _expenseTypeService.getAllExpenseTypes();
      setState(() {
        _expenseTypes = types;
        _isLoadingTypes = false;
      });

      // Set selected expense type if expense is already loaded
      if (_expense != null && _expense!.expenseTypeId != null) {
        setState(() {
          _selectedExpenseType = types.firstWhere(
            (type) => type.id == _expense!.expenseTypeId,
            orElse: () => types.first,
          );
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingTypes = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                    ?.errorLoadingExpenseTypes(e.toString()) ??
                'Error loading expense types: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _updateExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedExpenseType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.pleaseSelectExpenseType ??
              'Please select an expense type'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Sanitize amount (replace comma with dot)
      final sanitizedAmount = _amountController.text.replaceAll(',', '.');
      final amount = double.parse(sanitizedAmount);

      final updatedExpense = _expense!.copyWith(
        id: _expense!.id,
        title: _titleController.text,
        description: _descriptionController.text,
        amount: amount,
        date: _selectedDate,
        expenseTypeId: _selectedExpenseType!.id!,
      );

      await _expenseService.updateExpense(updatedExpense);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/view-expenses');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)?.errorGeneric(e.toString()) ??
                    'Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteExpense() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _expenseService.deleteExpense(_expense!.id!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/view-expenses');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)?.errorGeneric(e.toString()) ??
                    'Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _isLoadingTypes || _isLoadingExpense;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Expense'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/view-expenses'),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(kPadding16),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TitleField(controller: _titleController),
                    const LargeSpacing(),
                    DescriptionField(controller: _descriptionController),
                    const LargeSpacing(),
                    AmountField(controller: _amountController),
                    const LargeSpacing(),
                    DateField(
                      selectedDate: _selectedDate,
                      onTap: _selectDate,
                    ),
                    const LargeSpacing(),
                    ExpenseTypeDropdown(
                      expenseTypes: _expenseTypes,
                      selected: _selectedExpenseType,
                      onChanged: (v) =>
                          setState(() => _selectedExpenseType = v),
                    ),
                    const SizedBox(height: kPadding32),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        onPressed: _isLoading ? null : _updateExpense,
                        child: _isLoading
                            ? const SizedBox(
                                height: kPadding16,
                                width: kPadding16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Update Expense'),
                      ),
                    ),
                    const MediumSpacing(),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        onPressed: _isLoading ? null : _deleteExpense,
                        backgroundColor: Colors.red,
                        child: const Text('Delete Expense'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
