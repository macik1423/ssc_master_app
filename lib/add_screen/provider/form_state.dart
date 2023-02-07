import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:interview/models/contractor_name.dart';

import '../../models/invoice_number.dart';

class FormModel extends ChangeNotifier {
  FormzStatus _status = FormzStatus.pure;
  InvoiceNumber _invoiceNumber = const InvoiceNumber.pure();
  ContractorName _contractorName = const ContractorName.pure();

  FormzStatus get status => _status;
  InvoiceNumber get invoiceNumber => _invoiceNumber;
  ContractorName get contractorName => _contractorName;

  void setInvoiceNumber(input) {
    _invoiceNumber = InvoiceNumber.dirty(value: input);
  }

  void setContractorName(input) {
    _contractorName = ContractorName.dirty(value: input);
  }

  void save() {
    _status = Formz.validate([invoiceNumber, contractorName]);
    notifyListeners();
  }
}
