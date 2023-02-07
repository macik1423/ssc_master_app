import 'package:formz/formz.dart';

enum ContractorNameError { empty }

class ContractorName extends FormzInput<String, ContractorNameError> {
  const ContractorName.pure() : super.pure('');

  const ContractorName.dirty({String value = ''}) : super.dirty(value);

  @override
  ContractorNameError? validator(String value) {
    return value.isNotEmpty == true ? null : ContractorNameError.empty;
  }
}
