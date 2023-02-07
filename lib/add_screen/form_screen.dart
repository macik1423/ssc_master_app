import 'package:flutter/material.dart';
import 'package:interview/add_screen/provider/form_state.dart';
import 'package:provider/provider.dart';

class AddForm extends StatefulWidget {
  const AddForm({Key? key}) : super(key: key);

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: const [
            _InvoiceNumberInput(),
            _ContractorNameInput(),
          ],
        ),
      ),
    );
  }
}

class _InvoiceNumberInput extends StatelessWidget {
  const _InvoiceNumberInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final invoiceNumberStatus = context.watch<FormModel>().invoiceNumber;
    return TextField(
      onChanged: (input) {
        context.read<FormModel>().setInvoiceNumber(input);
      },
      decoration: InputDecoration(
        labelText: 'Nr faktury',
        errorText: invoiceNumberStatus.invalid ? 'brak numeru faktury' : null,
      ),
    );
  }
}

class _ContractorNameInput extends StatelessWidget {
  const _ContractorNameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contractorNameStatus = context.watch<FormModel>().contractorName;
    return TextField(
      onChanged: (input) {
        context.read<FormModel>().setContractorName(input);
      },
      decoration: InputDecoration(
        labelText: 'Nazwa kontrahenta',
        errorText:
            contractorNameStatus.invalid ? 'brak nazwy kontrahenta' : null,
      ),
    );
  }
}
