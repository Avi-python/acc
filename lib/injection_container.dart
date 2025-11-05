import 'package:acc/providers/sync_provider.dart';
import 'package:acc/providers/transaction_provider.dart';
import 'package:acc/repositories/transaction_repo.dart';
import 'package:acc/services/notion_service.dart';
import 'package:acc/services/sync_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final sl = GetIt.instance;

Future<void> initInjectionContainer() async {

  // Logger
  sl.registerSingleton<Logger>(Logger());

  // Repositories
  sl.registerLazySingleton<TransactionRepository>(
          () => TransactionRepository());

  // Service
  sl.registerLazySingleton<NotionService>(
          () => NotionService(sl()));

  sl.registerLazySingleton<SyncService>(
      () => SyncService(sl(), sl(), sl())
  );

  // Providers
  sl.registerLazySingleton<SyncProvider>(
      () => SyncProvider(sl(), sl())
  );

  sl.registerFactory<TransactionProvider>(
      () => TransactionProvider(sl<TransactionRepository>()));

}
