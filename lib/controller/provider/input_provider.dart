import 'package:flutter/material.dart';

class InputProvider extends ChangeNotifier {
  String? _error_text = null;
  String? get error_text => _error_text;

  void setErrorText(String errorText) {
    _error_text = errorText;
    notifyListeners();
  }
}
