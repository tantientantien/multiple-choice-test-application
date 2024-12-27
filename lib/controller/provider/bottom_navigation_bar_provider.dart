import 'package:flutter/material.dart';

class BottomNavigationBarProvider extends ChangeNotifier {
  int _index_item = 0;
  int get index_item => _index_item;

  void setIndexItem(int index) {
    _index_item = index;
    notifyListeners();
  }
}
