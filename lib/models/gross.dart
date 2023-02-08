import 'package:formz/formz.dart';

enum GrossError {
  empty('Pole nie może być puste'),
  smallerOrEqualZero('wartość musi być > 0');

  final String label;

  const GrossError(this.label);
}

class Gross extends FormzInput<String, GrossError> {
  const Gross.pure() : super.pure('');

  const Gross.dirty({String value = ''}) : super.dirty(value);

  @override
  GrossError? validator(String value) {
    return value.isEmpty
        ? GrossError.empty
        : int.parse(value) <= 0
            ? GrossError.smallerOrEqualZero
            : null;
  }
}
