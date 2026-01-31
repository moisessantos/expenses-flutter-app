import 'package:expenses_app/constants.dart';
import 'package:expenses_app/widgets/large_spacing.dart';
import 'package:expenses_app/widgets/small_spacing.dart';
import 'package:flutter/material.dart';
import 'package:expenses_app/l10n/app_localizations.dart';
import '../models/expense_type.dart';
import 'app_button.dart';

class TitleField extends StatelessWidget {
  final TextEditingController controller;
  const TitleField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)?.labelTitle ?? 'Title',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.title),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppLocalizations.of(context)?.pleaseEnterTitle ??
              'Please enter a title';
        }
        return null;
      },
    );
  }
}

class DescriptionField extends StatelessWidget {
  final TextEditingController controller;
  const DescriptionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText:
            AppLocalizations.of(context)?.labelDescription ?? 'Description',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.description),
      ),
      maxLines: 3,
    );
  }
}

class AmountField extends StatelessWidget {
  final TextEditingController controller;
  const AmountField({super.key, required this.controller});

  String _sanitizeAmount(String value) {
    // Replace comma with dot for decimal separator
    return value.replaceAll(',', '.');
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)?.labelAmount ?? 'Amount',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.attach_money),
        hintText: '0.00 or 0,00',
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        // Auto-replace comma with dot as user types
        if (value.contains(',')) {
          final sanitized = _sanitizeAmount(value);
          final cursorPosition = controller.selection.base.offset;
          controller.value = TextEditingValue(
            text: sanitized,
            selection: TextSelection.collapsed(offset: cursorPosition),
          );
        }
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppLocalizations.of(context)?.pleaseEnterAmount ??
              'Please enter an amount';
        }
        final sanitized = _sanitizeAmount(value);
        final amount = double.tryParse(sanitized);
        if (amount == null || amount <= 0) {
          return AppLocalizations.of(context)?.pleaseEnterValidAmount ??
              'Please enter a valid amount greater than 0';
        }
        return null;
      },
    );
  }
}

class DateField extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onTap;
  const DateField({super.key, required this.selectedDate, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)?.labelDate ?? 'Date',
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
      ),
    );
  }
}

class ExpenseTypeDropdown extends StatelessWidget {
  final List<ExpenseType> expenseTypes;
  final ExpenseType? selected;
  final ValueChanged<ExpenseType?> onChanged;

  const ExpenseTypeDropdown(
      {super.key,
      required this.expenseTypes,
      required this.selected,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ExpenseType>(
      value: selected,
      decoration: InputDecoration(
        labelText:
            AppLocalizations.of(context)?.labelExpenseType ?? 'Expense Type',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.category),
      ),
      items: expenseTypes.map((type) {
        return DropdownMenuItem<ExpenseType>(
          value: type,
          child: Row(
            children: [
              Container(
                width: kPadding24,
                height: kPadding24,
                decoration: BoxDecoration(
                  color: Color(int.parse('0xFF${type.color.substring(1)}')),
                  shape: BoxShape.circle,
                ),
              ),
              const SmallSpacing(),
              Text(type.name),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return AppLocalizations.of(context)?.pleaseSelectExpenseType ??
              'Please select an expense type';
        }
        return null;
      },
    );
  }
}

class EmptyExpenseTypesCard extends StatelessWidget {
  final VoidCallback onCreate;
  const EmptyExpenseTypesCard({super.key, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LargeSpacing(),
        Card(
          color: Colors.orange.shade100,
          child: Padding(
            padding: kScreenPadding,
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)?.noExpenseTypesAvailable ??
                      'No expense types available.',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SmallSpacing(),
                // Use AppButton for consistent styled buttons
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    onPressed: onCreate,
                    child: Text(
                        AppLocalizations.of(context)?.createExpenseType ??
                            'Create Expense Type'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SaveButton extends StatelessWidget {
  final bool isLoading;
  final bool disabled;
  final VoidCallback onPressed;

  const SaveButton(
      {super.key,
      required this.isLoading,
      required this.disabled,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        onPressed: isLoading || disabled ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: kPadding16,
                width: kPadding16,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : Text(AppLocalizations.of(context)?.saveExpense ?? 'Save Expense'),
      ),
    );
  }
}
