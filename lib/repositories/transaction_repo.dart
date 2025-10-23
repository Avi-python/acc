import 'package:hive/hive.dart';
import '../../models/transaction.dart';

class TransactionRepository {
  static const String _boxName = 'transactions';
  Box<Transaction>? _box;

  // Initialize Hive
  Future<void> init() async {
    // Open box
    _box = await Hive.openBox<Transaction>(_boxName);
  }

  Future<void> _ensureBoxIsOpen() async {
    if (_box == null || !_box!.isOpen) {
      await init();
    }
  }

  // CREATE - Add a new transaction
  Future<void> addTransaction(Transaction transaction) async {
    await _ensureBoxIsOpen();
    await _box!.put(transaction.id, transaction);
  }

  // READ - Get single transaction
  Future<Transaction?> getTransaction(String id) async {
    await _ensureBoxIsOpen();
    return _box!.get(id);
  }

  // READ - Get all transactions
  Future<List<Transaction>> getAllTransactions() async {
    await _ensureBoxIsOpen();
    return _box!.values.toList();
  }

  // READ - Get transactions by type
  Future<List<Transaction>> getTransactionsByType(TransactionType type) async {
    await _ensureBoxIsOpen();
    return _box!.values.where((t) => t.type == type).toList();
  }

  // READ - Get transactions by date range
  Future<List<Transaction>> getTransactionsByDateRange(
      DateTime start, DateTime end) async {
    await _ensureBoxIsOpen();
    return _box!.values.where((t) {
      return t.date.isAfter(start) && t.date.isBefore(end);
    }).toList();
  }

  // READ - Get transactions by category
  Future<List<Transaction>> getTransactionsByCategory(String category) async {
    await _ensureBoxIsOpen();
    return _box!.values.where((t) => t.category == category).toList();
  }

  // UPDATE - Update existing transaction
  Future<void> updateTransaction(Transaction transaction) async {
    await _ensureBoxIsOpen();
    await _box!.put(transaction.id, transaction);
  }

  // DELETE - Delete single transaction
  Future<void> deleteTransaction(String id) async {
    await _ensureBoxIsOpen();
    await _box!.delete(id);
  }

  // DELETE - Delete all transactions
  Future<void> deleteAllTransactions() async {
    await _ensureBoxIsOpen();
    await _box!.clear();
  }

  // STATISTICS - Get total income
  Future<double> getTotalIncome() async {
    await _ensureBoxIsOpen();
    return _box!.values
        .where((t) => t.type == TransactionType.income)
        .fold<double>(0.0, (double sum, Transaction t) => sum + t.amount);
  }

  // STATISTICS - Get total expenses
  Future<double> getTotalExpenses() async {
    await _ensureBoxIsOpen();
    return _box!.values
        .where((t) => t.type == TransactionType.expense)
        .fold<double>(0.0, (double sum, Transaction t) => sum + t.amount);
  }

  // STATISTICS - Get balance
  Future<double> getBalance() async {
    final income = await getTotalIncome();
    final expenses = await getTotalExpenses();
    return income - expenses;
  }

  // Get transactions sorted by date (newest first)
  Future<List<Transaction>> getTransactionsSortedByDate() async {
    final transactions = await getAllTransactions();
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions;
  }

  // Close box when done
  Future<void> close() async {
    await _box!.close();
  }
}
