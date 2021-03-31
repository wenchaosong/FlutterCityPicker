import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  Color _themeColor = Colors.blue;

  Color get themeColor => _themeColor;

  setTheme(Color themeColor) {
    _themeColor = themeColor;
    notifyListeners();
  }
}
