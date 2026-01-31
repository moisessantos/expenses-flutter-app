# Flutter Budget App

A comprehensive Flutter budgeting application built with clean architecture principles, featuring MongoDB integration and efficient expense management.

## Features

- **Expense Management**: Add, view, and organize your expenses
- **Expense Categories**: Create custom expense types with color coding
- **MongoDB Integration**: Persistent data storage using MongoDB Atlas
- **Clean Architecture**: Service/Repository pattern with dependency injection
- **Modern UI**: Material Design 3 with intuitive navigation
- **Mobile First**: Optimized for iOS and Android platforms

## Architecture

This app follows the **Service/Repository pattern** with clear separation of concerns:

```
lib/
├── models/          # Data models (Expense, ExpenseType)
├── repositories/    # Data access layer (MongoDB integration)
├── services/        # Business logic layer
├── screens/         # UI screens
├── routing/         # GoRouter configuration
└── di/             # Dependency injection setup
```

## Technology Stack

- **Flutter**: Cross-platform UI framework
- **MongoDB**: Database (using mongo_dart package)
- **GoRouter**: Declarative routing
- **Provider**: State management and dependency injection
- **JSON Serialization**: Automated with build_runner

### Prerequisites

- Flutter SDK (^3.6.2)
- Dart SDK
- MongoDB Atlas account (or local MongoDB instance)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd expenses-app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate model code:
```bash
dart run build_runner build
```

4. Configure MongoDB:
   - Copy the environment template file:
     ```bash
     cp lib/config/env.example.dart lib/config/env.dart
     ```
   - Edit `lib/config/env.dart` and update the MongoDB connection string with your credentials:
     ```dart
     static const String mongoDbConnectionString = 
         'mongodb+srv://YOUR_USERNAME:YOUR_PASSWORD@YOUR_CLUSTER.mongodb.net/YOUR_DATABASE';
     ```
   - **Important**: Never commit `lib/config/env.dart` to version control (it's already in .gitignore)

5. Run the app:
```bash
flutter run
```

## Usage

### Main Features

1. **Home Screen**: Navigation hub with quick access to all features
2. **Add Expense Type**: Create custom categories with color coding
3. **Add Expense**: Record new expenses with title, description, amount, and category
4. **View Expenses**: Browse all expenses with sorting and filtering options

### Navigation Routes

- `/` - Home screen
- `/add-expense` - Add new expense
- `/add-expense-type` - Create expense categories
- `/view-expenses` - View and manage all expenses

## Database Schema

### ExpenseType Collection
```json
{
  "_id": "string",
  "name": "string",
  "description": "string", 
  "color": "string (hex)",
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

### Expense Collection
```json
{
  "_id": "string",
  "title": "string",
  "description": "string",
  "amount": "double",
  "date": "DateTime", 
  "expenseTypeId": "ObjectId",
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

### User Collection
```json
{
  "_id": "string",
  "name": "string",
  "salt": "string",
  "passwordHash": "double",
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```


## Development

### Project Structure

- **Models**: Data classes with JSON serialization
- **Repositories**: Database access with error handling  
- **Services**: Business logic and validation
- **Screens**: UI components with state management
- **DI Container**: Singleton dependency injection
- **Router**: GoRouter configuration for navigation

### Code Generation

When modifying models, regenerate serialization code:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Localization

The app supports multiple languages (English and Portuguese). Translation files are located in `lib/l10n/`.

Generate localization files after modifying `.arb` files:
```bash
flutter gen-l10n
```

To add a new language:
1. Create a new `.arb` file (e.g., `intl_es.arb` for Spanish)
2. Add translations following the same structure as `intl_en.arb`
3. Run `flutter gen-l10n` to generate the Dart classes
4. Update `supportedLocales` in `main.dart` if needed

### Testing

Run tests:
```bash
flutter test
```

Build for production:
```bash
flutter build apk          # Android
flutter build ios          # iOS
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and ensure code quality
5. Submit a pull request

## License

This project is licensed under the MIT License.
