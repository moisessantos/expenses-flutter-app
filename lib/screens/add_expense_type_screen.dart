import 'package:expenses_app/widgets/large_spacing.dart';
import 'package:expenses_app/widgets/small_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../di/dependency_container.dart';
import '../services/expense_type_service.dart';
import 'package:expenses_app/l10n/app_localizations.dart';
import '../widgets/add_expense_type_parts.dart';
import 'package:expenses_app/constants.dart';

class AddExpenseTypeScreen extends StatefulWidget {
  const AddExpenseTypeScreen({super.key});

  @override
  State<AddExpenseTypeScreen> createState() => _AddExpenseTypeScreenState();
}

class _AddExpenseTypeScreenState extends State<AddExpenseTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Color _selectedColor = Colors.blue;
  bool _isLoading = false;

  late final ExpenseTypeService _expenseTypeService;

  final List<Color> _availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    _expenseTypeService = DependencyContainer().expenseTypeService;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveExpenseType() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Convert Color to hex string (RRGGBB format)
      final r = ((_selectedColor.r * 255.0).round() & 0xff)
          .toRadixString(16)
          .padLeft(2, '0');
      final g = ((_selectedColor.g * 255.0).round() & 0xff)
          .toRadixString(16)
          .padLeft(2, '0');
      final b = ((_selectedColor.b * 255.0).round() & 0xff)
          .toRadixString(16)
          .padLeft(2, '0');
      final colorHex = '#$r$g$b'.toUpperCase();

      await _expenseTypeService.createExpenseType(
        name: _nameController.text,
        description: _descriptionController.text,
        color: colorHex,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.expenseTypeCreated ??
                'Expense type created successfully!'),
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
        title: Text(AppLocalizations.of(context)?.addExpenseTypeTitle ??
            'Add Expense Type'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kPadding16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NameField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppLocalizations.of(context)?.pleaseEnterName ??
                        'Please enter a name';
                  }
                  return null;
                },
              ),
              const LargeSpacing(),
              DescriptionField(
                controller: _descriptionController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppLocalizations.of(context)
                            ?.pleaseEnterDescription ??
                        'Please enter a description';
                  }
                  return null;
                },
              ),
              const LargeSpacing(),
              Text(
                AppLocalizations.of(context)?.labelSelectColor ??
                    'Select Color',
                style: const TextStyle(
                  fontSize: kMediumFontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SmallSpacing(),
              ColorPickerWrap(
                availableColors: _availableColors,
                selectedColor: _selectedColor,
                onSelect: (c) => setState(() => _selectedColor = c),
              ),
              const SizedBox(height: kPadding32),
              SaveTypeButton(
                  isLoading: _isLoading, onPressed: _saveExpenseType),
            ],
          ),
        ),
      ),
    );
  }
}
