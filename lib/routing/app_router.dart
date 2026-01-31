import 'package:expenses_app/widgets/large_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:expenses_app/l10n/app_localizations.dart';
import '../di/dependency_container.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/add_expense_screen.dart';
import '../screens/add_expense_type_screen.dart';
import '../screens/view_expenses_screen.dart';
import '../screens/update_expense_screen.dart';
import '../screens/update_expense_type_screen.dart';
import '../screens/expense_types_screen.dart';
import '../widgets/app_button.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/login',
    // Global redirect to ensure only authenticated users can access app routes.
    // If a saved userId exists -> go to '/'. Otherwise redirect to '/login'.
    redirect: (context, state) async {
      try {
        final prefs = DependencyContainer().preferencesService;
        final saved = await prefs.loadUserId();
        final isLogin = state.uri.path == '/login';
        if (saved != null && isLogin) return '/';
        if (saved == null && state.uri.path != '/login') return '/login';
      } catch (e) {
        // If preferences can't be read yet, default to showing login
        if (state.uri.path != '/login') return '/login';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/add-expense',
        name: 'add-expense',
        builder: (context, state) => const AddExpenseScreen(),
      ),
      GoRoute(
        path: '/add-expense-type',
        name: 'add-expense-type',
        builder: (context, state) => const AddExpenseTypeScreen(),
      ),
      GoRoute(
        path: '/expense-types',
        name: 'expense-types',
        builder: (context, state) => const ExpenseTypesScreen(),
      ),
      GoRoute(
        path: '/view-expenses',
        name: 'view-expenses',
        builder: (context, state) => const ViewExpensesScreen(),
      ),
      GoRoute(
        path: '/update-expense/:id',
        name: 'update-expense',
        builder: (context, state) {
          final expenseId = state.pathParameters['id']!;
          return UpdateExpenseScreen(expenseId: expenseId);
        },
      ),
      GoRoute(
        path: '/update-expense-type/:id',
        name: 'update-expense-type',
        builder: (context, state) {
          final expenseTypeId = state.pathParameters['id']!;
          return UpdateExpenseTypeScreen(expenseTypeId: expenseTypeId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.pageNotFoundTitle ??
            'Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const LargeSpacing(),
            Text(
              AppLocalizations.of(context)
                      ?.pageNotFoundMessage(state.uri.toString()) ??
                  'Page not found: ${state.uri.toString()}',
              style: const TextStyle(fontSize: 18),
            ),
            const LargeSpacing(),
            SizedBox(
              width: 160,
              child: AppButton(
                onPressed: () => context.go('/'),
                child: Text(AppLocalizations.of(context)?.goHome ?? 'Go Home'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
