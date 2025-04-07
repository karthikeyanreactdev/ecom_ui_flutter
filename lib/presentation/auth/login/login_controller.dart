import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';
import '../../../routes/app_routes.dart';
import '../../../core/constants/text_constants.dart';

class LoginController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  // Form controllers and key
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable variables
  final passwordVisible = false.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }

  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return TextConstants.requiredField;
    }
    if (!GetUtils.isEmail(value)) {
      return TextConstants.invalidEmail;
    }
    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return TextConstants.requiredField;
    }
    if (value.length < 6) {
      return TextConstants.passwordTooShort;
    }
    return null;
  }

  // Login button press handler
  Future<void> onLoginPressed() async {
    // Validate form
    // if (!formKey.currentState!.validate()) {
    //   return;
    // }

    try {
      isLoading.value = true;

      // Call login API
      final response = await _apiService.post(
        '/auth/login',
        data: {
          'mobile': emailController.text.trim(),
          'password': passwordController.text,
        },
      );

      // Handle response
      if (response.statusCode == 200) {
        const toke1n =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3ZjI3N2Y3NWQ1NzBjMTA0NTM2MmJiMyIsImlhdCI6MTc0NDAyNzQyNywiZXhwIjoxNzQ0NjMyMjI3fQ.JRMI_BbMoMqLQ0CHqyeQZ2ImlaS3uvKTeMWbfZGwPNg';
        Get.offAllNamed(AppRoutes.dashboard);

        final String token = toke1n; //response.data['token'];
        final String refreshToken = response.data['refreshToken'];

        // Save tokens
        await _storageService.saveToken(token);
        await _storageService.saveRefreshToken(refreshToken);

        // Save user data if returned
        if (response.data['user'] != null) {
          // Save user to local storage
          // This would use the UserModel but for now we'll just use the userId
          await _storageService.saveUserId(response.data['user']['_id']);
        }

        // Navigate to dashboard
        // Get.offAllNamed(AppRoutes.dashboard);
      } else {
        // Handle error
        Get.snackbar(
          'Login Failed',
          'Please check your credentials and try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // For development/testing without backend
  void mockLogin() {
    Get.offAllNamed(AppRoutes.dashboard);
  }
}
