import 'package:expenses_app/widgets/large_spacing.dart';
import 'package:expenses_app/widgets/medium_spacing.dart';
import 'package:flutter/material.dart';
import '../di/dependency_container.dart';
import 'package:expenses_app/constants.dart';
import 'package:expenses_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.appTitle ?? 'Budget App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value:
                    DependencyContainer().localeNotifier.value?.languageCode ??
                        'en',
                items: [
                  DropdownMenuItem(
                      value: 'en',
                      child: const Text('🇬🇧 EN',
                          style: TextStyle(color: Colors.black))),
                  DropdownMenuItem(
                      value: 'pt',
                      child: const Text('🇵🇹 PT',
                          style: TextStyle(color: Colors.black))),
                ],
                onChanged: (val) async {
                  if (val == null) return;
                  final locale = Locale(val);
                  DependencyContainer().localeNotifier.value = locale;
                  // Persist the user's choice via the preferences service
                  try {
                    await DependencyContainer()
                        .preferencesService
                        .saveLocale(locale);
                  } catch (e) {
                    // don't crash the UI if saving fails
                    // ignore: avoid_print
                    print('Failed to save locale: $e');
                  }
                },
                icon: const Icon(Icons.language, color: Colors.white),
                dropdownColor: Theme.of(context).colorScheme.surface,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(kPadding16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: kPadding24),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                    Theme.of(context).colorScheme.primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(kPadding16),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.account_balance_wallet,
                        size: 36,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const LargeSpacing(),
                    Text(
                      AppLocalizations.of(context)?.manageExpenses ??
                          'Manage your expenses efficiently',
                      style: const TextStyle(fontSize: kMediumFontSize),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: kPadding32),
            AppButton(
              onPressed: () => context.go('/add-expense'),
              leading: Icon(Icons.add, color: Colors.blue.shade300),
              backgroundColor: Colors.grey.shade300,
              textColor: Colors.black,
              child: Text(AppLocalizations.of(context)?.addNewExpense ??
                  'Add New Expense'),
            ),
            const MediumSpacing(),
            AppButton(
              onPressed: () => context.go('/expense-types'),
              leading:
                  Icon(Icons.category_outlined, color: Colors.purple.shade300),
              backgroundColor: Colors.grey.shade300,
              textColor: Colors.black,
              child: Text(AppLocalizations.of(context)?.viewExpenseTypes ??
                  'View Expense Types'),
            ),
            const MediumSpacing(),
            AppButton(
              onPressed: () => context.go('/view-expenses'),
              leading: const Icon(Icons.list, color: Colors.white),
              child: Text(AppLocalizations.of(context)?.viewAllExpenses ??
                  'View All Expenses'),
            ),
          ],
        ),
      ),
    );
  }
}
