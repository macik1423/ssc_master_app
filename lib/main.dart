import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:interview/add_screen/clound_db.dart';
import 'package:interview/add_screen/db_api.dart';
import 'package:interview/add_screen/provider/form_state.dart';
import 'package:interview/models/invoice_dto.dart';

import 'add_screen/form_screen.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
              final formState = context.read<FormModel>();
              formState.saveValidate();
              _tryToSaveInDb(formState);
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

  void _tryToSaveInDb(FormModel formState) {
    formState.sendToDb();
    if (formState.status.isValid) {
      final newInvoice = InvoiceDto(
        contractorName: formState.contractorName.value,
        invoiceNumber: formState.invoiceNumber.value,
      );
      widget.db.addInvoice(newInvoice).whenComplete(
        () {
          successNotification();
          formState.success();
        },
      ).onError(
        (error, stackTrace) {
          errorNotification();
          formState.failure();
        },
      );
    } else if (formState.status.isSubmissionInProgress) {
      inProgressNotification();
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      inProgressNotification() {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(IconData(0xe6cc, fontFamily: 'MaterialIcons'),
                color: Colors.amber),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Dodawanie...',
              ),
            ),
          ],
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      errorNotification() {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(IconData(0xe6cc, fontFamily: 'MaterialIcons'),
                color: Colors.redAccent),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Error',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void successNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(IconData(0xe6cc, fontFamily: 'MaterialIcons'),
                color: Colors.lightGreen),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Dodano',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
