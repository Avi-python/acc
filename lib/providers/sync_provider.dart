import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../services/sync_service.dart';

class SyncProvider extends ChangeNotifier {
  final SyncService _syncService;
  final Logger _logger;

  SyncProvider(this._syncService, this._logger);

  SyncStatus _status = SyncStatus.idle;
  String? _message;
  DateTime? _lastSyncTime;

  SyncStatus get status => _status;
  String? get message => _message;
  DateTime? get lastSyncTime => _lastSyncTime;
  bool get isSyncing => _status == SyncStatus.syncing;

  // Trigger sync
  Future<void> sync() async {
    _status = SyncStatus.syncing;
    _message = 'Syncing...';
    notifyListeners();

    final result = await _syncService.syncTransactions();

    _status = result.status;
    _message = result.message;
    _lastSyncTime = DateTime.now();
    notifyListeners();
  }

  // Auto-sync (call this periodically or on app resume)
  Future<void> autoSync() async {
    if (_status == SyncStatus.syncing) return; // Already syncing

    final hasInternet = await _syncService.hasInternetConnection();
    if (!hasInternet) return; // No internet, skip

    await sync();
  }
}
