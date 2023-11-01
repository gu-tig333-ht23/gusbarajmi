import 'package:flutter/material.dart';

class FilterState extends ChangeNotifier {
  String selectedFilter = 'All Tasks';

  void setFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }
}
