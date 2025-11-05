import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';
import '../models/transaction.dart';
import '../repositories/transaction_repo.dart';
import 'notion_service.dart';

enum SyncStatus {
  idle,
  syncing,
  success,
  error,
}

class SyncService {
  final TransactionRepository _localRepo;
  final NotionService _notionService;
  final Logger _logger;

  SyncService(this._localRepo, this._notionService, this._logger);

  // Check internet connection
  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Main sync function - Call this to sync everything
  Future<SyncResult> syncTransactions() async {
    _logger.i('🔄 Starting sync...');

    // Check internet
    if (!await hasInternetConnection()) {
      return SyncResult(
        status: SyncStatus.error,
        message: 'No internet connection',
      );
    }

    try {
      // 1. Get all local transactions that need syncing
      final localTransactions = await _localRepo.getAllTransactions();

      int uploaded = 0;
      int updated = 0;
      int deleted = 0;
      List<String> errors = [];

      // 2. Sync each transaction
      for (final transaction in localTransactions) {
        try {
          if (transaction.isDeleted && transaction.notionId != null) {
            // Delete from Notion and local
            await _notionService.deleteNotionEntry(transaction.notionId!);
            await _localRepo.deleteTransaction(transaction.id);
            deleted++;
          } else if (!transaction.isSynced && !transaction.isDeleted) {
            // New transaction - upload to Notion
            final notionId = await _notionService.createNotionEntry(transaction);
            transaction.notionId = notionId;
            transaction.isSynced = true;
            transaction.lastSyncedAt = DateTime.now();
            await _localRepo.updateTransaction(transaction);
            uploaded++;
          } else if(transaction.isSynced && transaction.lastUpdatedAt.isAfter(transaction.lastSyncedAt!)) {
            // Existing transaction - update in Notion
            await _notionService.updateNotionEntry(
              transaction.notionId!,
              transaction,
            );
            transaction.isSynced = true;
            transaction.lastSyncedAt = DateTime.now();
            await _localRepo.updateTransaction(transaction);
            updated++;
          }
        } catch (e) {
          errors.add('${transaction.name}: $e');
          _logger.e('❌ Error syncing ${transaction.name}: $e');
        }
      }

      _logger.i('✅ Sync complete: $uploaded uploaded, $updated updated, $deleted deleted');

      return SyncResult(
        status: errors.isEmpty ? SyncStatus.success : SyncStatus.error,
        message: errors.isEmpty
            ? 'Synced: $uploaded new, $updated updated, $deleted deleted'
            : 'Partial sync: ${errors.length} errors',
        uploadedCount: uploaded,
        updatedCount: updated,
        deletedCount: deleted,
        errors: errors,
      );
    } catch (e) {
      _logger.e('❌ Sync failed: $e');
      return SyncResult(
        status: SyncStatus.error,
        message: 'Sync failed: $e',
      );
    }
  }

  // Mark transaction as needing sync
  Future<void> markForSync(Transaction transaction) async {
    transaction.isSynced = false;
    await _localRepo.updateTransaction(transaction);
  }

  // Soft delete (mark for deletion, will be deleted on next sync)
  Future<void> softDelete(Transaction transaction) async {
    transaction.isDeleted = true;
    transaction.isSynced = false;
    await _localRepo.updateTransaction(transaction);
  }
}

class SyncResult {
  final SyncStatus status;
  final String message;
  final int uploadedCount;
  final int updatedCount;
  final int deletedCount;
  final List<String> errors;

  SyncResult({
    required this.status,
    required this.message,
    this.uploadedCount = 0,
    this.updatedCount = 0,
    this.deletedCount = 0,
    this.errors = const [],
  });
}
