import 'package:flutter/material.dart';

class CoreState extends ChangeNotifier {
  bool _isEnabled = true;

  bool get isEnabled => _isEnabled;
  set isEnabled(bool value) {
    _isEnabled = value;
    notifyListeners();
  }
}
