import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses App'**
  String get appTitle;

  /// No description provided for @filterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by Date'**
  String get filterByDate;

  /// No description provided for @filterByCategory.
  ///
  /// In en, this message translates to:
  /// **'Filter by Category'**
  String get filterByCategory;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get allTime;

  /// No description provided for @lastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last Week'**
  String get lastWeek;

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get lastMonth;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @selectRange.
  ///
  /// In en, this message translates to:
  /// **'Select Range'**
  String get selectRange;

  /// No description provided for @customRange.
  ///
  /// In en, this message translates to:
  /// **'Custom Range'**
  String get customRange;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data to display'**
  String get noData;

  /// No description provided for @noExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses found'**
  String get noExpenses;

  /// No description provided for @noExpensesPeriod.
  ///
  /// In en, this message translates to:
  /// **'No expenses found for selected period'**
  String get noExpensesPeriod;

  /// No description provided for @addFirstExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Your First Expense'**
  String get addFirstExpense;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses: {count}'**
  String totalExpenses(Object count);

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount: \${total}'**
  String totalAmount(Object total);

  /// No description provided for @expensesByCategory.
  ///
  /// In en, this message translates to:
  /// **'Expenses by Category'**
  String get expensesByCategory;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'User name'**
  String get usernameLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid name or password'**
  String get authInvalidCredentials;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Your Budget App'**
  String get welcomeMessage;

  /// No description provided for @manageExpenses.
  ///
  /// In en, this message translates to:
  /// **'Manage your expenses efficiently'**
  String get manageExpenses;

  /// No description provided for @addNewExpense.
  ///
  /// In en, this message translates to:
  /// **'Add New Expense'**
  String get addNewExpense;

  /// No description provided for @addExpenseType.
  ///
  /// In en, this message translates to:
  /// **'Add Expense Type'**
  String get addExpenseType;

  /// No description provided for @viewAllExpenses.
  ///
  /// In en, this message translates to:
  /// **'View All Expenses'**
  String get viewAllExpenses;

  /// No description provided for @errorLoadingExpenses.
  ///
  /// In en, this message translates to:
  /// **'Error loading expenses: {error}'**
  String errorLoadingExpenses(Object error);

  /// No description provided for @allExpensesTitle.
  ///
  /// In en, this message translates to:
  /// **'All Expenses'**
  String get allExpensesTitle;

  /// No description provided for @sortByDate.
  ///
  /// In en, this message translates to:
  /// **'Sort by Date'**
  String get sortByDate;

  /// No description provided for @sortByAmount.
  ///
  /// In en, this message translates to:
  /// **'Sort by Amount'**
  String get sortByAmount;

  /// No description provided for @sortByTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort by Title'**
  String get sortByTitle;

  /// No description provided for @pageNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get pageNotFoundTitle;

  /// No description provided for @pageNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'Page not found: {path}'**
  String pageNotFoundMessage(Object path);

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get goHome;

  /// No description provided for @errorLoadingExpenseTypes.
  ///
  /// In en, this message translates to:
  /// **'Error loading expense types: {error}'**
  String errorLoadingExpenseTypes(Object error);

  /// No description provided for @pleaseSelectExpenseType.
  ///
  /// In en, this message translates to:
  /// **'Please select an expense type'**
  String get pleaseSelectExpenseType;

  /// No description provided for @expenseCreated.
  ///
  /// In en, this message translates to:
  /// **'Expense created successfully!'**
  String get expenseCreated;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorGeneric(Object error);

  /// No description provided for @addExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpenseTitle;

  /// No description provided for @labelTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get labelTitle;

  /// No description provided for @labelDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get labelDescription;

  /// No description provided for @labelAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get labelAmount;

  /// No description provided for @labelDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get labelDate;

  /// No description provided for @labelExpenseType.
  ///
  /// In en, this message translates to:
  /// **'Expense Type'**
  String get labelExpenseType;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseEnterTitle;

  /// No description provided for @pleaseEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get pleaseEnterAmount;

  /// No description provided for @pleaseEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount greater than 0'**
  String get pleaseEnterValidAmount;

  /// No description provided for @noExpenseTypesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No expense types available.'**
  String get noExpenseTypesAvailable;

  /// No description provided for @createExpenseType.
  ///
  /// In en, this message translates to:
  /// **'Create Expense Type'**
  String get createExpenseType;

  /// No description provided for @saveExpense.
  ///
  /// In en, this message translates to:
  /// **'Save Expense'**
  String get saveExpense;

  /// No description provided for @expenseTypeCreated.
  ///
  /// In en, this message translates to:
  /// **'Expense type created successfully!'**
  String get expenseTypeCreated;

  /// No description provided for @expenseTypeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Expense type updated successfully!'**
  String get expenseTypeUpdated;

  /// No description provided for @addExpenseTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Expense Type'**
  String get addExpenseTypeTitle;

  /// No description provided for @updateExpenseTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Expense Type'**
  String get updateExpenseTypeTitle;

  /// No description provided for @updateExpenseType.
  ///
  /// In en, this message translates to:
  /// **'Update Expense Type'**
  String get updateExpenseType;

  /// No description provided for @labelName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get labelName;

  /// No description provided for @labelSelectColor.
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get labelSelectColor;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterName;

  /// No description provided for @pleaseEnterDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get pleaseEnterDescription;

  /// No description provided for @saveExpenseType.
  ///
  /// In en, this message translates to:
  /// **'Save Expense Type'**
  String get saveExpenseType;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @expenseTypesTitle.
  ///
  /// In en, this message translates to:
  /// **'Expense Types'**
  String get expenseTypesTitle;

  /// No description provided for @viewExpenseTypes.
  ///
  /// In en, this message translates to:
  /// **'View Expense Types'**
  String get viewExpenseTypes;

  /// No description provided for @noExpenseTypesYet.
  ///
  /// In en, this message translates to:
  /// **'No expense types yet'**
  String get noExpenseTypesYet;

  /// No description provided for @addFirstType.
  ///
  /// In en, this message translates to:
  /// **'Add Your First Type'**
  String get addFirstType;

  /// No description provided for @deleteExpenseType.
  ///
  /// In en, this message translates to:
  /// **'Delete Expense Type'**
  String get deleteExpenseType;

  /// No description provided for @deleteExpenseTypeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This action cannot be undone.'**
  String deleteExpenseTypeConfirm(String name);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @expenseTypeDeleted.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted successfully'**
  String expenseTypeDeleted(String name);

  /// No description provided for @errorDeletingExpenseType.
  ///
  /// In en, this message translates to:
  /// **'Error deleting expense type: {error}'**
  String errorDeletingExpenseType(String error);

  /// No description provided for @cannotDeleteExpenseTypeInUse.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete this expense type because it is being used by {count} expense(s)'**
  String cannotDeleteExpenseTypeInUse(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
