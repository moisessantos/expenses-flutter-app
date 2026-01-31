// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Expenses App';

  @override
  String get filterByDate => 'Filter by Date';

  @override
  String get filterByCategory => 'Filter by Category';

  @override
  String get allTime => 'All Time';

  @override
  String get lastWeek => 'Last Week';

  @override
  String get lastMonth => 'Last Month';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get selectRange => 'Select Range';

  @override
  String get customRange => 'Custom Range';

  @override
  String get noData => 'No data to display';

  @override
  String get noExpenses => 'No expenses found';

  @override
  String get noExpensesPeriod => 'No expenses found for selected period';

  @override
  String get addFirstExpense => 'Add Your First Expense';

  @override
  String totalExpenses(Object count) {
    return 'Total Expenses: $count';
  }

  @override
  String totalAmount(Object total) {
    return 'Total Amount: \$$total';
  }

  @override
  String get expensesByCategory => 'Expenses by Category';

  @override
  String get loginTitle => 'Login';

  @override
  String get usernameLabel => 'User name';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get authInvalidCredentials => 'Invalid name or password';

  @override
  String get welcomeMessage => 'Welcome to Your Budget App';

  @override
  String get manageExpenses => 'Manage your expenses efficiently';

  @override
  String get addNewExpense => 'Add New Expense';

  @override
  String get addExpenseType => 'Add Expense Type';

  @override
  String get viewAllExpenses => 'View All Expenses';

  @override
  String errorLoadingExpenses(Object error) {
    return 'Error loading expenses: $error';
  }

  @override
  String get allExpensesTitle => 'All Expenses';

  @override
  String get sortByDate => 'Sort by Date';

  @override
  String get sortByAmount => 'Sort by Amount';

  @override
  String get sortByTitle => 'Sort by Title';

  @override
  String get pageNotFoundTitle => 'Page Not Found';

  @override
  String pageNotFoundMessage(Object path) {
    return 'Page not found: $path';
  }

  @override
  String get goHome => 'Go Home';

  @override
  String errorLoadingExpenseTypes(Object error) {
    return 'Error loading expense types: $error';
  }

  @override
  String get pleaseSelectExpenseType => 'Please select an expense type';

  @override
  String get expenseCreated => 'Expense created successfully!';

  @override
  String errorGeneric(Object error) {
    return 'Error: $error';
  }

  @override
  String get addExpenseTitle => 'Add Expense';

  @override
  String get labelTitle => 'Title';

  @override
  String get labelDescription => 'Description';

  @override
  String get labelAmount => 'Amount';

  @override
  String get labelDate => 'Date';

  @override
  String get labelExpenseType => 'Expense Type';

  @override
  String get pleaseEnterTitle => 'Please enter a title';

  @override
  String get pleaseEnterAmount => 'Please enter an amount';

  @override
  String get pleaseEnterValidAmount =>
      'Please enter a valid amount greater than 0';

  @override
  String get noExpenseTypesAvailable => 'No expense types available.';

  @override
  String get createExpenseType => 'Create Expense Type';

  @override
  String get saveExpense => 'Save Expense';

  @override
  String get expenseTypeCreated => 'Expense type created successfully!';

  @override
  String get expenseTypeUpdated => 'Expense type updated successfully!';

  @override
  String get addExpenseTypeTitle => 'Add Expense Type';

  @override
  String get updateExpenseTypeTitle => 'Update Expense Type';

  @override
  String get updateExpenseType => 'Update Expense Type';

  @override
  String get labelName => 'Name';

  @override
  String get labelSelectColor => 'Select Color';

  @override
  String get pleaseEnterName => 'Please enter a name';

  @override
  String get pleaseEnterDescription => 'Please enter a description';

  @override
  String get saveExpenseType => 'Save Expense Type';

  @override
  String get unknown => 'Unknown';

  @override
  String get expenseTypesTitle => 'Expense Types';

  @override
  String get viewExpenseTypes => 'View Expense Types';

  @override
  String get noExpenseTypesYet => 'No expense types yet';

  @override
  String get addFirstType => 'Add Your First Type';

  @override
  String get deleteExpenseType => 'Delete Expense Type';

  @override
  String deleteExpenseTypeConfirm(String name) {
    return 'Are you sure you want to delete \"$name\"? This action cannot be undone.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String expenseTypeDeleted(String name) {
    return '$name deleted successfully';
  }

  @override
  String errorDeletingExpenseType(String error) {
    return 'Error deleting expense type: $error';
  }

  @override
  String cannotDeleteExpenseTypeInUse(int count) {
    return 'Cannot delete this expense type because it is being used by $count expense(s)';
  }
}
