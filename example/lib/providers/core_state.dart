import 'package:flutter/material.dart';

class CoreState extends ChangeNotifier {
  bool _isDisabled = false;

  bool get isDisabled => _isDisabled;
  set isDisabled(bool value) {
    _isDisabled = value;
    notifyListeners();
  }
}
