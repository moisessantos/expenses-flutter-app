import 'package:json_annotation/json_annotation.dart';
import 'expense_type.dart';

part 'expense.g.dart';

@JsonSerializable()
class Expense {
  @JsonKey(name: '_id')
  final String? id;

  final String title;
  final String? description;
  final double amount;
  final DateTime date;
  @JsonKey(name: 'expenseTypeId')
  final String? expenseTypeId;
  final DateTime createdAt;
  final DateTime updatedAt;

  // This field is not stored in MongoDB but populated when fetching
  @JsonKey(includeFromJson: false, includeToJson: false)
  final ExpenseType? expenseType;

  const Expense({
    this.id,
    required this.title,
    this.description,
    required this.amount,
    required this.date,
    this.expenseTypeId,
    required this.createdAt,
    required this.updatedAt,
    this.expenseType,
  });

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseToJson(this);

  Expense copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    DateTime? date,
    String? expenseTypeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    ExpenseType? expenseType,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      expenseTypeId: expenseTypeId ?? this.expenseTypeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expenseType: expenseType ?? this.expenseType,
    );
  }

  @override
  String toString() {
    return 'Expense{id: $id, title: $title, amount: $amount€, date: $date, expenseType: ${expenseType?.name}}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expense &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          amount == other.amount;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ amount.hashCode;
}
