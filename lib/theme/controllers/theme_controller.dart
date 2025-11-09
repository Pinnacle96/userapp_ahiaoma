// theme/controllers/theme_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController with ChangeNotifier {
  final SharedPreferences sharedPreferences; // non-nullable
  ThemeController({required this.sharedPreferences}) {
    _loadCurrentTheme();
    _loadSavedColors();
    notifyListeners(); // ensure initial rebuilds (hot-restart friendly)
  }

  // Brand defaults
  static const Color _defaultPrimary   = Color(0xFF107A2B); // Forest Green
  static const Color _defaultSecondary = Color(0xFFD4A124); // Yellow

  // Persisted keys (avoid typos)
  static const String _kThemeKey           = AppConstants.theme;
  static const String _kPrimaryARGBKey     = 'brand_primary_argb';
  static const String _kSecondaryARGBKey   = 'brand_secondary_argb';

  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  Color? _selectedPrimaryColor;
  Color? _selectedSecondaryColor;

  // Safe getters (never null)
  Color get selectedPrimaryColor   => _selectedPrimaryColor   ?? _defaultPrimary;
  Color get selectedSecondaryColor => _selectedSecondaryColor ?? _defaultSecondary;

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    sharedPreferences.setBool(_kThemeKey, _darkTheme);
    notifyListeners();
  }

  void _loadCurrentTheme() {
    _darkTheme = sharedPreferences.getBool(_kThemeKey) ?? false;
  }

  // Persist brand colors (ARGB ints), with sensible defaults
  void _loadSavedColors() {
    final p = sharedPreferences.getInt(_kPrimaryARGBKey);
    final s = sharedPreferences.getInt(_kSecondaryARGBKey);
    _selectedPrimaryColor   = p != null ? Color(p) : _defaultPrimary;
    _selectedSecondaryColor = s != null ? Color(s) : _defaultSecondary;
  }

  void setThemeColor({Color? primaryColor, Color? secondaryColor}) {
    if (primaryColor != null)  {
      _selectedPrimaryColor = primaryColor;
      sharedPreferences.setInt(_kPrimaryARGBKey, primaryColor.value);
    }
    if (secondaryColor != null) {
      _selectedSecondaryColor = secondaryColor;
      sharedPreferences.setInt(_kSecondaryARGBKey, secondaryColor.value);
    }
    notifyListeners();
  }

  // Optional helper to go back to defaults
  void resetBrandColors() {
    _selectedPrimaryColor = _defaultPrimary;
    _selectedSecondaryColor = _defaultSecondary;
    sharedPreferences.setInt(_kPrimaryARGBKey, _defaultPrimary.value);
    sharedPreferences.setInt(_kSecondaryARGBKey, _defaultSecondary.value);
    notifyListeners();
  }
}
