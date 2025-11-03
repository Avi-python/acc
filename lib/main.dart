import 'package:acc/models/transaction.dart';
import 'package:acc/widgets/home_widget_handler.dart';
import 'package:flutter/material.dart';
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
  // BUG : why do I need to init hive here again?
  Hive.init(dir.path);
  Hive.registerAdapter<Transaction>(TransactionAdapter());
  Hive.registerAdapter<TransactionType>(TransactionTypeAdapter());
  HomeWidgetHandler.registerCallbacks();
  runApp(const MyApp());
}

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
