import 'dart:convert';
import 'package:acc/models/transaction.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'providers/transaction_provider.dart';
import 'pages/home_page.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initInjectionContainer();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter<Transaction>(TransactionAdapter());
  Hive.registerAdapter<TransactionType>(TransactionTypeAdapter());
  runApp(const MyApp());
  // HomeWidget.registerInteractivityCallback(counterCallBack);
}

// @pragma('vm:entry-point')
// Future<void> counterCallBack(Uri? uri) async {
//   if (uri?.scheme == "counter" && uri?.host == "timeout") {
//     final int counterValue =
//         await HomeWidget.getWidgetData('counter', defaultValue: 0) as int;
//     _createNotionEntry(counterValue);

//     final String? historyJson =
//         await HomeWidget.getWidgetData<String>('counter_history');
//     List<int> history = [];
//     if (historyJson != null && historyJson.isNotEmpty) {
//       history =
//           (historyJson.split(',').map((e) => int.tryParse(e) ?? 0).toList());
//     }
//     history.add(counterValue);
//     await HomeWidget.saveWidgetData<String>(
//         'counter_history', history.join(','));

//     await HomeWidget.saveWidgetData<int>('counter', 0);
//     await HomeWidget.updateWidget(name: 'CounterWidgetReceiver');
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.sl<TransactionProvider>()..loadTransactions(),
        ),
      ],
      child: MaterialApp(
        title: 'Transaction App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
