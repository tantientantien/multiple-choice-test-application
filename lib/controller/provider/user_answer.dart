import 'package:flutter/material.dart';

class AnswerProvider extends ChangeNotifier {
  List<String?> selectedOptions = [];

  void updateSelectedOptions(List<String?> newOptions) {
    selectedOptions = newOptions;
    notifyListeners();
  }
}


