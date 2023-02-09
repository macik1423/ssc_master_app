import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:interview/add_screen/provider/form_state.dart';
import 'package:interview/models/provider/vat_amount_state.dart';
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
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _SaveButton(db: widget.db),
              const InvoiceNumberInput(),
              const ContractorNameInput(),
              const NetWorthInput(),
              const _VatAmount(),
              const _GrossInput(),
            ],
          ),
        ),
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
        netWorth: int.parse(formState.netWorth.value),
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

class InvoiceNumberInput extends StatefulWidget {
  const InvoiceNumberInput({Key? key}) : super(key: key);

  @override
  State<InvoiceNumberInput> createState() => _InvoiceNumberInputState();
}

class _InvoiceNumberInputState extends State<InvoiceNumberInput> {
  @override
  Widget build(BuildContext context) {
    final invoiceNumberStatus = context.watch<FormModel>().invoiceNumber;
    final formzState = context.watch<FormModel>();

    return TextField(
      // controller: textEditingController,
      controller: formzState.invoiceController,
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

class ContractorNameInput extends StatefulWidget {
  const ContractorNameInput({Key? key}) : super(key: key);

  @override
  State<ContractorNameInput> createState() => _ContractorNameInputState();
}

class _ContractorNameInputState extends State<ContractorNameInput> {
  @override
  Widget build(BuildContext context) {
    final contractorNameStatus = context.watch<FormModel>().contractorName;
    final formzState = context.watch<FormModel>();

    return TextField(
      controller: formzState.contractorNameController,
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

class NetWorthInput extends StatefulWidget {
  const NetWorthInput({Key? key}) : super(key: key);

  @override
  State<NetWorthInput> createState() => _NetWorthInputState();
}

class _NetWorthInputState extends State<NetWorthInput> {
  @override
  Widget build(BuildContext context) {
    final netWorthStatus = context.watch<FormModel>().netWorth;
    final vatAmount = context.watch<VatAmountState>().value;
    final formState = context.watch<FormModel>();

    return TextField(
      keyboardType: TextInputType.number,
      controller: formState.netWorthController,
      onChanged: (input) {
        context.read<FormModel>().setNetWorth(input);
        context.read<FormModel>().setGross(input, vatAmount);
      },
      decoration: InputDecoration(
        labelText: 'Kwota netto',
        errorText:
            netWorthStatus.invalid ? '${netWorthStatus.error?.label}' : null,
      ),
    );
  }
}

class _VatAmount extends StatefulWidget {
  const _VatAmount({Key? key}) : super(key: key);

  @override
  State<_VatAmount> createState() => _VatAmountState();
}

class _VatAmountState extends State<_VatAmount> {
  static const List<int> vatAmounts = [0, 7, 23];
  int dropdownValue = vatAmounts.first;
  @override
  Widget build(BuildContext context) {
    final formState = context.watch<FormModel>();

    return Row(
      children: [
        const Text('Podatek vat:'),
        const Padding(
          padding: EdgeInsets.only(right: 10.0),
        ),
        DropdownButton(
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          items: vatAmounts
              .map<DropdownMenuItem>((value) => DropdownMenuItem(
                    value: value,
                    child: Text(
                      '$value%',
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            context.read<VatAmountState>().setValue(value);
            setState(() {
              dropdownValue = value;
            });
          },
          value: dropdownValue,
        ),
      ],
    );
  }
}

class _GrossInput extends StatefulWidget {
  const _GrossInput({Key? key}) : super(key: key);

  @override
  State<_GrossInput> createState() => _GrossInputState();
}

class _GrossInputState extends State<_GrossInput> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    final provider = context.read<FormModel>();
    super.initState();
    textEditingController = TextEditingController(text: provider.gross.value);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = context.watch<FormModel>();
    final netWorthStatus = formState.netWorth;
    final vatAmount = context.watch<VatAmountState>().value;
    final grossStatus = formState.gross;

    final gross = netWorthStatus.value != ''
        ? int.parse(netWorthStatus.value) * (1 + vatAmount * 0.01)
        : '';
    textEditingController.text = '$gross';

    return TextField(
      controller: textEditingController,
      onChanged: (input) {
        formState.setGross(input, vatAmount);
      },
      decoration: InputDecoration(
        labelText: 'Kwota brutto',
        errorText: grossStatus.invalid ? '${grossStatus.error?.label}' : null,
      ),
    );
  }
}
