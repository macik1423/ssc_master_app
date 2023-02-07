import 'package:flutter/material.dart';
import 'package:interview/add_screen/provider/form_state.dart';

import 'add_screen/form_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FormModel(),
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
      home: const MyHomePage(title: 'Interview app'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          ElevatedButton(
            onPressed: () {
              context.read<FormModel>().save();
            },
            child: const Icon(
              IconData(
                0xe550,
                fontFamily: 'MaterialIcons',
              ),
              size: 50,
            ),
          )
        ],
      ),
      body: const Center(
        child: AddForm(),
      ),
    );
  }
}
