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
  DateTime createdAt;

  @HiveField(6)
  DateTime lastUpdatedAt;

  @HiveField(7)
  String? notes;

  @HiveField(8)
  String? notionId; // Notion page ID

  @HiveField(9)
  bool isSynced; // Is it synced to Notion?

  @HiveField(10)
  DateTime? lastSyncedAt; // When was it last synced?

  @HiveField(11)
  bool isDeleted; // Soft delete flag


  Transaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.type,
    required this.category,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.notes,
    this.notionId,
    this.isSynced = false,
    this.lastSyncedAt,
    this.isDeleted = false,
  });

  // Helper method to convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'type': type.toString(),
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
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
