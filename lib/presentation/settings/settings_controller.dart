import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../../theme/theme_controller.dart';
import '../../data/models/user_model.dart';

class SettingsController extends GetxController {
  final ThemeController _themeController = Get.find<ThemeController>();
  final StorageService _storageService = Get.find<StorageService>();

  final RxBool isLoading = false.obs;
  final RxBool isDarkMode = false.obs;
  final RxBool pushNotificationsEnabled = true.obs;
  final RxBool emailNotificationsEnabled = true.obs;
  final RxBool biometricAuthEnabled = false.obs;
  final RxString selectedLanguage = 'English'.obs;
  final RxString selectedCurrency = 'USD'.obs;

  // User preferences
  final List<String> availableLanguages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
  ];
  final List<String> availableCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CAD',
    'AUD',
    'INR',
  ];

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    isLoading.value = true;

    try {
      // Load theme preference
      isDarkMode.value = _themeController.isDarkMode;

      // Load notification preferences
      pushNotificationsEnabled.value =
          await _storageService.getBool('push_notifications') ?? true;
      emailNotificationsEnabled.value =
          await _storageService.getBool('email_notifications') ?? true;

      // Load authentication preferences
      biometricAuthEnabled.value =
          await _storageService.getBool('biometric_auth') ?? false;

      // Load language preferences
      selectedLanguage.value =
          await _storageService.getString('language') ?? 'English';

      // Load currency preferences
      selectedCurrency.value =
          await _storageService.getString('currency') ?? 'USD';
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load settings',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleDarkMode(bool value) async {
    isDarkMode.value = value;
    _themeController.toggleTheme();
  }

  Future<void> togglePushNotifications(bool value) async {
    pushNotificationsEnabled.value = value;
    await _storageService.setBool('push_notifications', value);
  }

  Future<void> toggleEmailNotifications(bool value) async {
    emailNotificationsEnabled.value = value;
    await _storageService.setBool('email_notifications', value);
  }

  Future<void> toggleBiometricAuth(bool value) async {
    biometricAuthEnabled.value = value;
    await _storageService.setBool('biometric_auth', value);
  }

  Future<void> setLanguage(String language) async {
    if (availableLanguages.contains(language)) {
      selectedLanguage.value = language;
      await _storageService.setString('language', language);

      // Here you would implement the actual language change
      // For example, using GetX localization:
      // Get.updateLocale(Locale(languageCode));
    }
  }

  Future<void> setCurrency(String currency) async {
    if (availableCurrencies.contains(currency)) {
      selectedCurrency.value = currency;
      await _storageService.setString('currency', currency);
    }
  }

  Future<void> clearCache() async {
    isLoading.value = true;

    try {
      // Clear image cache
      imageCache.clear();

      // Clear any other app-specific caches
      // await _storageService.clearCache();

      Get.snackbar(
        'Success',
        'Cache cleared successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to clear cache',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      // Show confirmation dialog
      final bool confirmed =
          await Get.dialog(
            AlertDialog(
              title: const Text('Delete Account'),
              content: const Text(
                'Are you sure you want to delete your account? '
                'This action cannot be undone and all your data will be permanently deleted.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Get.back(result: true),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ) ??
          false;

      if (confirmed) {
        // TODO: Implement actual account deletion through API
        // For now, just log the user out and clear local data

        // Clear user data
        await _storageService.clearUserData();

        // Navigate to login screen
        Get.offAllNamed('/login');

        Get.snackbar(
          'Account Deleted',
          'Your account has been deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete account: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> logout() async {
    try {
      // Show confirmation dialog
      final bool confirmed =
          await Get.dialog(
            AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Get.back(result: true),
                  child: const Text('Logout'),
                ),
              ],
            ),
          ) ??
          false;

      if (confirmed) {
        // Clear authentication token
        await _storageService.clearToken();

        // Navigate to login screen
        Get.offAllNamed('/login');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
