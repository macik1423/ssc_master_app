import 'package:flutter/cupertino.dart';

class VatAmountState extends ChangeNotifier {
  int _value = 0;

  int get value => _value;

  void setValue(input) {
    _value = input;
    notifyListeners();
  }
}
