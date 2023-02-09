import 'package:flutter/material.dart';
import 'package:interview/add_screen/clound_db.dart';
import 'package:interview/add_screen/db_api.dart';
import 'package:interview/add_screen/provider/form_state.dart';
import 'package:interview/list_screen/list.dart';
import 'package:interview/models/provider/vat_amount_state.dart';

import 'add_screen/form_screen.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FormModel>(
          create: (_) => FormModel(),
        ),
        ChangeNotifierProvider<VatAmountState>(
          create: (_) => VatAmountState(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interview app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Interview app', db: CloudDb()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.db});

  final DbApi db;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  TextStyle optionStyle =
      const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  late List<Widget> _widgetOptions;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    final provider = context.read<FormModel>();
    provider.clear();
  }

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      AddForm(db: widget.db),
      ListScreen(db: widget.db),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: 'List',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      appBar: AppBar(
        title: Text(widget.title),
        leading: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Center(
            child: Image.asset(
              'lib/assets/logo.png',
            ),
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
        // child: AddForm(),
      ),
    );
  }
}
