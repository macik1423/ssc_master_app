import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:interview/models/contractor_name.dart';
import 'package:interview/models/net_worth.dart';

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
    notifyListeners();
  }

  void failure() {
    _status = FormzStatus.submissionFailure;
  }
}
