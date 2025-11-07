import 'package:acc/models/transaction.dart';
import 'package:acc/providers/sync_provider.dart';
import 'package:acc/widgets/home_widget_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'providers/transaction_provider.dart';
import 'pages/home_page.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await di.initInjectionContainer();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter<Transaction>(TransactionAdapter());
  Hive.registerAdapter<TransactionType>(TransactionTypeAdapter());
  registerHomeWidgetCallbacks();
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
        ChangeNotifierProvider<SyncProvider>(
            create: (_) => di.sl<SyncProvider>()
        )
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
