import 'package:formz/formz.dart';

enum VatAmountError {
  empty('Pole nie może być puste');

  final String label;

  const VatAmountError(this.label);
}

class VatAmount extends FormzInput<String, VatAmountError> {
  const VatAmount.pure() : super.pure('');

  const VatAmount.dirty({String value = ''}) : super.dirty(value);

  @override
  VatAmountError? validator(String value) {
    return value.isNotEmpty ? null : VatAmountError.empty;
  }
}
