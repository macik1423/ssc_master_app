import 'package:formz/formz.dart';

enum InvoiceNumberError { empty }

class InvoiceNumber extends FormzInput<String, InvoiceNumberError> {
  const InvoiceNumber.pure() : super.pure('');

  const InvoiceNumber.dirty({String value = ''}) : super.dirty(value);

  @override
  InvoiceNumberError? validator(String value) {
    return value.isNotEmpty == true ? null : InvoiceNumberError.empty;
  }
}
