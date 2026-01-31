import 'package:flutter/material.dart';
import 'package:expenses_app/l10n/app_localizations.dart';
import 'package:expenses_app/constants.dart';

typedef CategorySelectionChanged = void Function(List<String> selected);

class CategoryFilterWidget extends StatelessWidget {
  final List<String> allCategories;
  final List<String> selectedCategories;
  final bool loading;
  final CategorySelectionChanged onToggle;

  const CategoryFilterWidget({
    super.key,
    required this.allCategories,
    required this.selectedCategories,
    required this.loading,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding16),
      child: ExpansionTile(
        title: Text(AppLocalizations.of(context)?.filterByCategory ??
            'Filter by Category'),
        initiallyExpanded: false,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: kPadding8),
            child: loading
                ? const Padding(
                    padding: EdgeInsets.all(kPadding8),
                    child: CircularProgressIndicator(),
                  )
                : Wrap(
                    spacing: kPadding8,
                    children: allCategories
                        .map((cat) => FilterChip(
                              label: Text(cat),
                              selected: selectedCategories.contains(cat),
                              onSelected: (_) {
                                final next =
                                    List<String>.from(selectedCategories);
                                if (next.contains(cat)) {
                                  next.remove(cat);
                                } else {
                                  next.add(cat);
                                }
                                onToggle(next);
                              },
                            ))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
