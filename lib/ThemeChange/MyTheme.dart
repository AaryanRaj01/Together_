import 'package:flutter/material.dart';

class MyTHeme with ChangeNotifier{
  static bool _isDark = true;

  ThemeMode currentTheme(){
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

}