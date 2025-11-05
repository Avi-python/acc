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
    final transaction = _box!.get(id);
    if(transaction == null || transaction.isDeleted) {
      return null;
    }
    return transaction;
  }

  Future<List<Transaction>> getAllActiveTransactions() async {
    await _ensureBoxIsOpen();
    return _box!.values.where((t) => !t.isDeleted).toList();
  }

  // READ - Get all transactions
  Future<List<Transaction>> getAllTransactions() async {
    await _ensureBoxIsOpen();
    return _box!.values.toList();
  }

  // UPDATE - Update existing transaction
  Future<void> updateTransaction(Transaction transaction) async {
    await _ensureBoxIsOpen();
    await _box!.put(transaction.id, transaction);
  }

  // DELETE - Soft delete single transaction
  Future<void> softDeleteTransaction(String id) async {
    await _ensureBoxIsOpen();
    final transaction = await getTransaction(id);
    if(transaction != null) {
      transaction.isDeleted = true;
      await transaction.save();
    }
  }

  // DELETE - Delete single transaction
  Future<void> deleteTransaction(String id) async {
    await _ensureBoxIsOpen();
    await _box!.delete(id);
  }

  // STATISTICS - Get total income
  Future<double> getTotalIncome() async {
    await _ensureBoxIsOpen();
    final transactions = await getAllActiveTransactions();
    return transactions
        .where((t) => t.type == TransactionType.income)
        .fold<double>(0.0, (double sum, Transaction t) => sum + t.amount);
  }

  // STATISTICS - Get total expenses
  Future<double> getTotalExpenses() async {
    await _ensureBoxIsOpen();
    final transactions = await getAllActiveTransactions();
    return transactions
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
    final transactions = await getAllActiveTransactions();
    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return transactions;
  }

  Future<void> refreshBox() async {
    if(_box!.isOpen) await _box?.close();
    _box = await Hive.openBox<Transaction>(_boxName);
  }

  // Close box when done
  Future<void> close() async {
    await _box!.close();
  }
}
