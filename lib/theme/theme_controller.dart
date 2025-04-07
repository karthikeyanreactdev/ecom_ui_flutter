import 'package:get/get.dart';
import 'theme_service.dart';

class ThemeController extends GetxController {
  final ThemeService _themeService = Get.find<ThemeService>();
  
  bool get isDarkMode => _themeService.isDarkMode;
  
  void toggleTheme() {
    _themeService.toggleTheme();
    update();
  }
  
  void setThemeMode(bool isDark) {
    _themeService.setThemeMode(isDark);
    update();
  }
}
