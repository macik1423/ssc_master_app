import 'package:formz/formz.dart';

enum NetWorthError {
  empty('Pole nie możę być puste'),
  smallerOrEqualZero('wartość musi być > 0'),
  unknown('Unknown');

  final String label;

  const NetWorthError(this.label);
}

class NetWorth extends FormzInput<String, NetWorthError> {
  const NetWorth.pure() : super.pure('');

  const NetWorth.dirty({String value = ''}) : super.dirty(value);

  @override
  NetWorthError? validator(String value) {
    return value.isEmpty
        ? NetWorthError.empty
        : int.parse(value) <= 0
            ? NetWorthError.smallerOrEqualZero
            : null;
  }
}
