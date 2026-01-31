import 'package:expenses_app/widgets/large_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../di/dependency_container.dart';
import '../services/expense_service.dart';
import '../services/expense_type_service.dart';
import '../models/expense_type.dart';
import 'package:expenses_app/l10n/app_localizations.dart';
import '../widgets/add_expense_parts.dart';
import 'package:expenses_app/constants.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  ExpenseType? _selectedExpenseType;
  List<ExpenseType> _expenseTypes = [];
  bool _isLoading = false;
  bool _isLoadingTypes = true;

  late final ExpenseService _expenseService;
  late final ExpenseTypeService _expenseTypeService;

  @override
  void initState() {
    super.initState();
    _expenseService = DependencyContainer().expenseService;
    _expenseTypeService = DependencyContainer().expenseTypeService;
    _loadExpenseTypes();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadExpenseTypes() async {
    try {
      final types = await _expenseTypeService.getAllExpenseTypes();
      setState(() {
        _expenseTypes = types;
        _isLoadingTypes = false;
      });
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

  Future<void> _saveExpense() async {
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

      await _expenseService.createExpense(
        title: _titleController.text,
        description: _descriptionController.text,
        amount: amount,
        date: _selectedDate,
        expenseTypeId: _selectedExpenseType!.id!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.expenseCreated ??
                'Expense created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/');
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context)?.addExpenseTitle ?? 'Add Expense'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: _isLoadingTypes
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
                    if (_expenseTypes.isEmpty)
                      EmptyExpenseTypesCard(
                          onCreate: () => context.go('/add-expense-type')),
                    const SizedBox(height: kPadding32),
                    SaveButton(
                      isLoading: _isLoading,
                      disabled: _expenseTypes.isEmpty,
                      onPressed: _saveExpense,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// extracted widgets are now in `lib/widgets/add_expense_fields.dart`
