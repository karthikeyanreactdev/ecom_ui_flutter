import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../../core/constants/text_constants.dart';

class ForgotPasswordController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  // Form controllers and key
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  
  // Observable variables
  final isLoading = false.obs;
  
  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
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
  
  // Send reset link button press handler
  Future<void> onSendLinkPressed() async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    try {
      isLoading.value = true;
      
      // Call forgot password API
      final response = await _apiService.post(
        '/auth/forgot-password',
        data: {
          'email': emailController.text.trim(),
        },
      );
      
      // Handle response
      if (response.statusCode == 200) {
        // Show success message
        Get.snackbar(
          'Success',
          'Password reset link has been sent to your email.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 3),
        );
        
        // Go back to login screen after delay
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
        
      } else {
        // Handle error
        Get.snackbar(
          'Failed',
          'Unable to send reset link. Please try again.',
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
  void mockSendLink() {
    Get.snackbar(
      'Demo Mode',
      'In a real app, a password reset link would be sent to your email.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
      duration: const Duration(seconds: 3),
    );
    
    // Go back to login screen after delay
    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
    });
  }
}
