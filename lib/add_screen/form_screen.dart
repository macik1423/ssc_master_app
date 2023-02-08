import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:interview/add_screen/provider/form_state.dart';
import 'package:provider/provider.dart';

import '../models/invoice_dto.dart';
import 'db_api.dart';

class AddForm extends StatefulWidget {
  const AddForm({Key? key, required this.db}) : super(key: key);
  final DbApi db;
  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          _SaveButton(db: widget.db),
          const _InvoiceNumberInput(),
          const _ContractorNameInput(),
        ],
      ),
    );
  }
}

class _SaveButton extends StatefulWidget {
  const _SaveButton({
    Key? key,
    required this.db,
  }) : super(key: key);

  final DbApi db;

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: ElevatedButton(
        onPressed: () {
          final formState = context.read<FormModel>();
          formState.saveValidate();
          _tryToSaveInDb(formState);
        },
        child: const Icon(
          IconData(0xe550, fontFamily: 'MaterialIcons'),
          size: 50,
        ),
      ),
    );
  }

  void _tryToSaveInDb(FormModel formState) {
    if (formState.status.isValid) {
      final newInvoice = InvoiceDto(
        contractorName: formState.contractorName.value,
        invoiceNumber: formState.invoiceNumber.value,
      );
      formState.sendToDb();
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

class _InvoiceNumberInput extends StatefulWidget {
  const _InvoiceNumberInput({Key? key}) : super(key: key);

  @override
  State<_InvoiceNumberInput> createState() => _InvoiceNumberInputState();
}

class _InvoiceNumberInputState extends State<_InvoiceNumberInput> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invoiceNumberStatus = context.watch<FormModel>().invoiceNumber;
    final formStatus = context.watch<FormModel>().status;
    return TextField(
      controller: formStatus.isSubmissionSuccess
          ? textEditingController
          : TextEditingController(
              text: invoiceNumberStatus.value,
            ),
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

class _ContractorNameInput extends StatefulWidget {
  const _ContractorNameInput({Key? key}) : super(key: key);

  @override
  State<_ContractorNameInput> createState() => _ContractorNameInputState();
}

class _ContractorNameInputState extends State<_ContractorNameInput> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contractorNameStatus = context.watch<FormModel>().contractorName;
    final formStatus = context.watch<FormModel>().status;
    return TextField(
      controller: formStatus.isSubmissionSuccess
          ? textEditingController
          : TextEditingController(
              text: contractorNameStatus.value,
            ),
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
