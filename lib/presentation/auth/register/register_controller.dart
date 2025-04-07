import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';
import '../../../routes/app_routes.dart';
import '../../../core/constants/text_constants.dart';

class RegisterController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();
  
  // Form controllers and key
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Observable variables
  final passwordVisible = false.obs;
  final confirmPasswordVisible = false.obs;
  final isLoading = false.obs;
  
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  
  // Toggle password visibility
  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }
  
  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    confirmPasswordVisible.value = !confirmPasswordVisible.value;
  }
  
  // Name validation
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return TextConstants.requiredField;
    }
    return null;
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
  
  // Phone validation
  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return TextConstants.requiredField;
    }
    if (!GetUtils.isPhoneNumber(value)) {
      return TextConstants.invalidPhone;
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
  
  // Confirm password validation
  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return TextConstants.requiredField;
    }
    if (value != passwordController.text) {
      return TextConstants.passwordsDontMatch;
    }
    return null;
  }
  
  // Register button press handler
  Future<void> onRegisterPressed() async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    try {
      isLoading.value = true;
      
      // Call register API
      final response = await _apiService.post(
        '/auth/register',
        data: {
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'password': passwordController.text,
        },
      );
      
      // Handle response
      if (response.statusCode == 201) {
        final String token = response.data['token'];
        final String refreshToken = response.data['refreshToken'];
        
        // Save tokens
        await _storageService.saveToken(token);
        await _storageService.saveRefreshToken(refreshToken);
        
        // Save user data if returned
        if (response.data['user'] != null) {
          // Save user to local storage
          await _storageService.saveUserId(response.data['user']['_id']);
        }
        
        // Navigate to dashboard
        Get.offAllNamed(AppRoutes.dashboard);
        
      } else {
        // Handle error
        Get.snackbar(
          'Registration Failed',
          'Please check your information and try again.',
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
  void mockRegister() {
    Get.offAllNamed(AppRoutes.dashboard);
  }
}
