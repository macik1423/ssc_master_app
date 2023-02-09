import 'package:flutter/material.dart';
import 'package:interview/add_screen/form_screen.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  static const double bottomModalSize = 300;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: bottomModalSize,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Edycja: ',
                  style: DefaultTextStyle.of(context).style,
                  children: [],
                ),
              ),
              const InvoiceNumberInput(),
              const ContractorNameInput(),
              const NetWorthInput(),
            ],
          ),
        ),
      ),
    );
  }
}
