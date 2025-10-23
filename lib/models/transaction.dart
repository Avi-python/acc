import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double amount;

  @HiveField(3)
  TransactionType type;

  @HiveField(4)
  String category;

  @HiveField(5)
  DateTime date;

  @HiveField(6)
  String? notes;

  Transaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.notes,
  });

  // Helper method to convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'type': type.toString(),
      'category': category,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }
}

@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  income,

  @HiveField(1)
  expense,
}
