import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

void main() {
  runApp(const MyApp());
  HomeWidget.registerInteractivityCallback(counterCallBack);
}

@pragma('vm:entry-point')
Future<void> counterCallBack(Uri? uri) async {
  print('CounterCallBack invoked: $uri');
  if (uri?.scheme == "counter" && uri?.host == "timeout") {
    final int counterValue =
        await HomeWidget.getWidgetData('counter', defaultValue: 0) as int;
    print('Current counter value: $counterValue');

    // TODO : save to supabase
    final String? historyJson =
        await HomeWidget.getWidgetData<String>('counter_history');
    List<int> history = [];
    print('Current history json: $historyJson');
    if (historyJson != null && historyJson.isNotEmpty) {
      history =
          (historyJson.split(',').map((e) => int.tryParse(e) ?? 0).toList());
    }
    history.add(counterValue);
    await HomeWidget.saveWidgetData<String>(
        'counter_history', history.join(','));

    await HomeWidget.saveWidgetData<int>('counter', 0);
    await HomeWidget.updateWidget(name: 'CounterWidgetReceiver');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<int> _counterHistory = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final int counterValue =
        await HomeWidget.getWidgetData('counter', defaultValue: 0) as int;
    final String? historyJson =
        await HomeWidget.getWidgetData<String>('counter_history');

    List<int> history = [];
    if (historyJson != null && historyJson.isNotEmpty) {
      history =
          historyJson.split(',').map((e) => int.tryParse(e) ?? 0).toList();
    }

    setState(() {
      _counter = counterValue;
      _counterHistory = history;
    });
  }

  Future<void> _incrementCounter() async {
    final int counterValue =
        await HomeWidget.getWidgetData('counter', defaultValue: 0) as int;
    final int newValue = counterValue + 1;
    await HomeWidget.saveWidgetData<int>('counter', newValue);
    await HomeWidget.updateWidget(name: 'CounterWidgetReceiver');
    setState(() {
      _counter = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadData,
              tooltip: 'Refresh History',
            )
          ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 40),
            if (_counterHistory.isNotEmpty) ...[
              const Divider(),
              const Text(
                'Accounting History:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: ListView.builder(
                itemCount: _counterHistory.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text('Gold: ${_counterHistory[index]}'),
                        subtitle: Text('HAHAHAHAHAHAH')),
                  );
                },
              ))
            ]
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
