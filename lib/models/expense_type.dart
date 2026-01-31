import 'package:json_annotation/json_annotation.dart';

part 'expense_type.g.dart';

@JsonSerializable()
class ExpenseType {
  @JsonKey(name: '_id')
  final String? id;

  final String name;
  final String description;
  final String color; // Hex color code
  final DateTime createdAt;
  final DateTime updatedAt;

  const ExpenseType({
    this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpenseType.fromJson(Map<String, dynamic> json) =>
      _$ExpenseTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseTypeToJson(this);

  ExpenseType copyWith({
    String? id,
    String? name,
    String? description,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseType(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ExpenseType{id: $id, name: $name, description: $description, color: $color}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseType &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
