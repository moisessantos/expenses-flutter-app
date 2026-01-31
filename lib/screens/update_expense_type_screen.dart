import 'package:expenses_app/widgets/large_spacing.dart';
import 'package:expenses_app/widgets/small_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../di/dependency_container.dart';
import '../services/expense_type_service.dart';
import '../models/expense_type.dart';
import 'package:expenses_app/l10n/app_localizations.dart';
import '../widgets/add_expense_type_parts.dart';
import 'package:expenses_app/constants.dart';

class UpdateExpenseTypeScreen extends StatefulWidget {
  final String expenseTypeId;

  const UpdateExpenseTypeScreen({super.key, required this.expenseTypeId});

  @override
  State<UpdateExpenseTypeScreen> createState() =>
      _UpdateExpenseTypeScreenState();
}

class _UpdateExpenseTypeScreenState extends State<UpdateExpenseTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Color _selectedColor = Colors.blue;
  bool _isLoading = true;
  bool _isSaving = false;
  ExpenseType? _expenseType;

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
    _loadExpenseType();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadExpenseType() async {
    try {
      final expenseType =
          await _expenseTypeService.getExpenseTypeById(widget.expenseTypeId);

      if (expenseType == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Expense type not found'),
              backgroundColor: Colors.red,
            ),
          );
          context.go('/expense-types');
        }
        return;
      }

      setState(() {
        _expenseType = expenseType;
        _nameController.text = expenseType.name;
        _descriptionController.text = expenseType.description;
        _selectedColor = _parseColor(expenseType.color);
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading expense type: $e'),
            backgroundColor: Colors.red,
          ),
        );
        context.go('/expense-types');
      }
    }
  }

  Color _parseColor(String colorHex) {
    try {
      final hex = colorHex.startsWith('#') ? colorHex.substring(1) : colorHex;
      return Color(int.parse('0xFF$hex'));
    } catch (_) {
      return Colors.blue;
    }
  }

  Future<void> _updateExpenseType() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_expenseType == null) return;

    setState(() {
      _isSaving = true;
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

      final updatedExpenseType = _expenseType!.copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
        color: colorHex,
      );

      await _expenseTypeService.updateExpenseType(updatedExpenseType);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.expenseTypeUpdated ??
                'Expense type updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/expense-types');
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
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.updateExpenseTypeTitle ??
            'Update Expense Type'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/expense-types'),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                          return AppLocalizations.of(context)
                                  ?.pleaseEnterName ??
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
                    UpdateTypeButton(
                      isLoading: _isSaving,
                      onPressed: _updateExpenseType,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
