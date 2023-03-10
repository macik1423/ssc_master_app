import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:interview/models/contractor_name.dart';
import 'package:interview/models/invoice_dto.dart';
import 'package:interview/models/net_worth.dart';
import 'package:interview/models/provider/vat_amount_state.dart';

import '../../models/gross.dart';
import '../../models/invoice_number.dart';

class FormModel extends ChangeNotifier {
  FormzStatus _status = FormzStatus.pure;
  InvoiceNumber _invoiceNumber = const InvoiceNumber.pure();
  ContractorName _contractorName = const ContractorName.pure();
  NetWorth _netWorth = const NetWorth.pure();
  Gross _gross = const Gross.pure();

  FormzStatus get status => _status;
  InvoiceNumber get invoiceNumber => _invoiceNumber;
  ContractorName get contractorName => _contractorName;
  NetWorth get netWorth => _netWorth;
  Gross get gross => _gross;

  TextEditingController _invoiceController = TextEditingController();
  TextEditingController get invoiceController => _invoiceController;

  TextEditingController _contractorNameController = TextEditingController();
  TextEditingController get contractorNameController =>
      _contractorNameController;

  TextEditingController _netWorthController = TextEditingController();
  TextEditingController get netWorthController => _netWorthController;

  void setInvoiceNumber(input) {
    _invoiceNumber = InvoiceNumber.dirty(value: input);
  }

  void setContractorName(input) {
    _contractorName = ContractorName.dirty(value: input);
  }

  void setNetWorth(input) {
    _netWorth = NetWorth.dirty(value: input);
    notifyListeners();
  }

  void setGross(input, vatAmount) {
    final gross =
        netWorth.value != '' ? int.parse(netWorth.value) * (1 + vatAmount) : '';
    _gross = Gross.dirty(value: input);
  }

  void saveValidate() {
    _invoiceNumber =
        _invoiceNumber.pure ? const InvoiceNumber.dirty() : _invoiceNumber;
    _contractorName =
        _contractorName.pure ? const ContractorName.dirty() : _contractorName;
    _netWorth = _netWorth.pure ? const NetWorth.dirty() : _netWorth;
    _gross = _gross.pure ? const Gross.dirty() : _gross;
    _status = Formz.validate([invoiceNumber, contractorName, netWorth, gross]);
    notifyListeners();
  }

  void sendToDb() {
    _status = FormzStatus.submissionInProgress;
  }

  void success() {
    _status = FormzStatus.submissionSuccess;
    _invoiceNumber = const InvoiceNumber.pure();
    _contractorName = const ContractorName.pure();
    _netWorth = const NetWorth.pure();
    _gross = const Gross.pure();

    _invoiceController = TextEditingController();
    _contractorNameController = TextEditingController();
    _netWorthController = TextEditingController();
    notifyListeners();
  }

  void failure() {
    _status = FormzStatus.submissionFailure;
  }

  void setEdit(InvoiceDto invoice) {
    _invoiceNumber = InvoiceNumber.dirty(value: invoice.invoiceNumber);
    _contractorName = ContractorName.dirty(value: invoice.contractorName);
    _netWorth = NetWorth.dirty(value: invoice.netWorth.toString());

    invoiceController.text = _invoiceNumber.value;
    contractorNameController.text = _contractorName.value;
    netWorthController.text = _netWorth.value;
  }

  void clear() {
    _status = FormzStatus.pure;
    _invoiceNumber = const InvoiceNumber.pure();
    _contractorName = const ContractorName.pure();
    _netWorth = const NetWorth.pure();
    _gross = const Gross.pure();

    _invoiceController = TextEditingController();
    _contractorNameController = TextEditingController();
    _netWorthController = TextEditingController();
    notifyListeners();
  }
}
