import 'package:acc/models/transaction.dart';
import 'package:hive/hive.dart';
import 'package:home_widget/home_widget.dart';
import 'package:path_provider/path_provider.dart';
import '../repositories/transaction_repo.dart';

class HomeWidgetHandler {
  static void registerCallbacks() {
    HomeWidget.registerInteractivityCallback(counterCallback);
  }

  static Future<void> _initHive() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    if (!Hive.isAdapterRegistered(0)) {
      print('Registering Transaction Adapter');
      Hive.registerAdapter<Transaction>(TransactionAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      print('Registering TransactionType Adapter');
      Hive.registerAdapter<TransactionType>(TransactionTypeAdapter());
    }
  }

  @pragma('vm:entry-point')
  static Future<void> counterCallback(Uri? uri) async {
    if (uri?.scheme == "counter" && uri?.host == "timeout") {
      final int counterValue =
          await HomeWidget.getWidgetData('counter', defaultValue: 0) as int;

      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: "Unknown",
        amount: counterValue.toDouble(),
        type: TransactionType.expense,
        category: "Unknown",
        date: DateTime.now(),
      );

      await _initHive();
      final repo = TransactionRepository();
      await repo.init();
      await repo.addTransaction(transaction);
      await repo.close();

      await HomeWidget.saveWidgetData<int>('counter', 0);
      await HomeWidget.updateWidget(name: 'CounterWidgetReceiver');
    }
  }
}
