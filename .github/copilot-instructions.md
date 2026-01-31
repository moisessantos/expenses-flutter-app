# Flutter Budgeting App - Copilot Instructions

This is a Flutter budgeting application with:
- Service/Repository pattern architecture
- MongoDB integration using mongo_dart
- GoRouter for navigation (add expense, add expense type, view expenses)
- Dependency injection following Flutter architecture guidelines

## Architecture
- `lib/models/` - Data models (Expense, ExpenseType)
- `lib/repositories/` - Data access layer with MongoDB integration
- `lib/services/` - Business logic layer
- `lib/screens/` - UI screens
- `lib/routing/` - GoRouter configuration
- `lib/di/` - Dependency injection setup

## MongoDB Connection
Connection string is stored in `lib/config/env.dart` (not in version control).
Use `lib/config/env.example.dart` as a template for local setup.

## Key Features
- Add new expenses
- Manage expense categories/types
- View all expenses with filtering
- Clean separation of concerns with dependency injection