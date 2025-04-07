import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();
  
  // Observable variables
  final user = Rxn<UserModel>();
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final isLoggedIn = false.obs;
  
  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  
  // Edit mode
  final isEditMode = false.obs;
  final isSaving = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }
  
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
  
  Future<void> checkLoginStatus() async {
    isLoading.value = true;
    
    try {
      // In a real app, this would check if the user is logged in
      final userData = await _storageService.getUser();
      
      if (userData != null) {
        isLoggedIn.value = true;
        user.value = userData;
        
        // Set form values
        nameController.text = userData.name;
        emailController.text = userData.email;
        phoneController.text = userData.phone ?? '';
      } else {
        isLoggedIn.value = false;
        user.value = null;
      }
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Failed to load user data';
      print('Error checking login status: $e');
    }
  }
  
  void enableEditMode() {
    isEditMode.value = true;
  }
  
  void cancelEdit() {
    // Reset form values
    if (user.value != null) {
      nameController.text = user.value!.name;
      emailController.text = user.value!.email;
      phoneController.text = user.value!.phone ?? '';
    }
    
    isEditMode.value = false;
  }
  
  Future<void> saveProfile() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    isSaving.value = true;
    
    try {
      // Create updated user model
      final updatedUser = user.value!.copyWith(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text.isEmpty ? null : phoneController.text,
      );
      
      // In a real app, this would send the updated user data to the API
      // await _apiService.updateUserProfile(updatedUser);
      
      // Mock API call
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Update local user data
      user.value = updatedUser;
      await _storageService.saveUser(updatedUser);
      
      isEditMode.value = false;
      isSaving.value = false;
      
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      isSaving.value = false;
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error updating profile: $e');
    }
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
        Get.offAllNamed('/login');
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
  
  Future<void> login() async {
    // Navigate to login screen
    Get.toNamed('/login');
  }
  
  void navigateToSettings() {
    Get.toNamed('/settings');
  }
  
  void navigateToOrders() {
    Get.toNamed('/orders');
  }
  
  void navigateToWishlist() {
    Get.toNamed('/wishlist');
  }
  
  void navigateToAddresses() {
    Get.toNamed('/shipping-addresses');
  }
  
  void navigateToPaymentMethods() {
    Get.toNamed('/payment-methods');
  }
}