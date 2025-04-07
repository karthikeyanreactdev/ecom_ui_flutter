import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/storage_constants.dart';

class ThemeService extends GetxService {
  late SharedPreferences _prefs;
  final _isDarkMode = false.obs;
  
  bool get isDarkMode => _isDarkMode.value;
  
  @override
  void onInit() {
    super.onInit();
    _initPrefs();
  }
  
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadThemeMode();
  }
  
  void _loadThemeMode() {
    final isDark = _prefs.getBool(StorageConstants.isDarkMode) ?? false;
    _isDarkMode.value = isDark;
    _updateTheme();
  }
  
  Future<void> toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;
    await _prefs.setBool(StorageConstants.isDarkMode, _isDarkMode.value);
    _updateTheme();
  }
  
  Future<void> setThemeMode(bool isDark) async {
    _isDarkMode.value = isDark;
    await _prefs.setBool(StorageConstants.isDarkMode, isDark);
    _updateTheme();
  }
  
  void _updateTheme() {
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
  
  ThemeMode getThemeMode() {
    return _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
  }
}
