import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Themeprovider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  Themeprovider({String? initialTheme}) {
    if (initialTheme != null) {
      _themeMode = stringToTheme(initialTheme);
    }
  }

  ThemeMode get currentTheme => _themeMode;

  void setTheme(ThemeMode theme) {
    _themeMode = theme;
    _saveToLocalDevice();
    notifyListeners();
  }

  _saveToLocalDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String saveSettingSting = _ThemeToString(_themeMode);
    prefs.setString("themeMode", saveSettingSting);
  }

  String _ThemeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return "system";
      case ThemeMode.light:
        return "light";
      case ThemeMode.dark:
        return "dark";
      default:
        return "system";
    }
  }

  Future<String> _getThemeFromLocalDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? themeMode = prefs.getString("themeMode");
    if (themeMode != null) {
      return themeMode;
    }
    return "system";

  }
  ThemeMode stringToTheme(String theme){
    switch(theme){
      case "system":
        return ThemeMode.system;
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

