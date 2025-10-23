import 'package:acc/providers/transaction_provider.dart';
import 'package:acc/repositories/transaction_repo.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initInjectionContainer() async {
  // Repositories
  sl.registerLazySingleton<TransactionRepository>(
      () => TransactionRepository());

  // Providers
  sl.registerFactory<TransactionProvider>(
      () => TransactionProvider(sl<TransactionRepository>()));
}
