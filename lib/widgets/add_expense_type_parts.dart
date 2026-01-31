import 'package:expenses_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:expenses_app/l10n/app_localizations.dart';
import 'app_button.dart';

class NameField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const NameField({super.key, required this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)?.labelName ?? 'Name',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.label),
      ),
      validator: validator,
    );
  }
}

class DescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const DescriptionField({super.key, required this.controller, this.validator});

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
      validator: validator,
    );
  }
}

class ColorPickerWrap extends StatelessWidget {
  final List<Color> availableColors;
  final Color selectedColor;
  final ValueChanged<Color> onSelect;

  const ColorPickerWrap(
      {super.key,
      required this.availableColors,
      required this.selectedColor,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: availableColors.map((color) {
        return GestureDetector(
          onTap: () => onSelect(color),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: selectedColor == color
                  ? Border.all(color: Colors.black, width: 3)
                  : null,
            ),
            child: selectedColor == color
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
        );
      }).toList(),
    );
  }
}

class SaveTypeButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  const SaveTypeButton(
      {super.key, required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: kPadding16,
                width: kPadding16,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : Text(AppLocalizations.of(context)?.saveExpenseType ??
                'Save Expense Type'),
      ),
    );
  }
}

class UpdateTypeButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  const UpdateTypeButton(
      {super.key, required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: kPadding16,
                width: kPadding16,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : Text(AppLocalizations.of(context)?.updateExpenseType ??
                'Update Expense Type'),
      ),
    );
  }
}
