import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';
import '../../../services/storage_service.dart';
import '../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  // Observable variables
  final user = Rxn<UserModel>();
  final isLoggedIn = false.obs;

  // Dark mode
  final isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
    checkThemeMode();
  }

  void checkLoginStatus() async {
    try {
      // In a real app, this would check if the user is logged in
      final userData = await _storageService.getUser();

      if (userData != null) {
        isLoggedIn.value = true;
        user.value = userData;
      } else {
        isLoggedIn.value = false;
        user.value = null;
      }
    } catch (e) {
      print('Error checking login status: $e');
    }
  }

  void checkThemeMode() {
    try {
      final darkMode = _storageService.getDarkMode();
      isDarkMode.value = darkMode;
    } catch (e) {
      print('Error checking theme mode: $e');
    }
  }

  void toggleDarkMode(bool value) async {
    try {
      isDarkMode.value = value;
      await _storageService.setDarkMode(value);

      // Update theme
      Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    } catch (e) {
      print('Error toggling dark mode: $e');
    }
  }

  void navigateToLogin() {
    Get.toNamed(AppRoutes.login);
  }

  void navigateToEditProfile() {
    Get.toNamed(AppRoutes.editProfile);
  }

  void navigateToOrders() {
    Get.toNamed(AppRoutes.orders);
  }

  void navigateToWishlist() {
    Get.toNamed(AppRoutes.wishlist);
  }

  void navigateToAddresses() {
    Get.toNamed(AppRoutes.shippingAddresses);
  }

  void navigateToPaymentMethods() {
    Get.toNamed(AppRoutes.paymentMethods);
  }

  void navigateToSettings() {
    Get.toNamed(AppRoutes.settings);
  }

  void navigateToHelp() {
    // Navigate to help screen
  }

  Future<void> logout() async {
    try {
      // Show confirmation dialog
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Log Out'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        // In a real app, this would clear the session
        await _storageService.clearSession();

        // Reset user data
        user.value = null;
        isLoggedIn.value = false;

        // Navigate to login screen
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to log out',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error logging out: $e');
    }
  }
}
