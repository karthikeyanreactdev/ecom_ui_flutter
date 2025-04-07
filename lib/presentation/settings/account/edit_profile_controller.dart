import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/user_model.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';

class EditProfileController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();
  
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final Rx<File?> profileImageFile = Rx<File?>(null);
  
  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }
  
  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
  
  Future<void> loadUserData() async {
    isLoading.value = true;
    
    try {
      // Load user from local storage
      user.value = await _storageService.getUser();
      
      if (user.value != null) {
        firstNameController.text = user.value!.firstName;
        lastNameController.text = user.value!.lastName;
        emailController.text = user.value!.email;
        phoneController.text = user.value!.phone ?? '';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load user data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        profileImageFile.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;
    
    isUpdating.value = true;
    
    try {
      if (user.value == null) {
        throw Exception('User data not found');
      }
      
      // Prepare updated user data
      final updatedUser = UserModel.fromFirstLastName(
        id: user.value!.id,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: user.value!.email,
        phone: phoneController.text,
        avatar: user.value!.avatar,
        addresses: user.value!.addresses,
        createdAt: user.value!.createdAt,
        updatedAt: DateTime.now(),
      );
      
      // Upload image if a new one was selected
      if (profileImageFile.value != null) {
        // In a real app, you would upload the image to the server
        // and get back the URL to use as avatar
        // For now, we'll just assume it's successful
        
        // Mock implementation:
        // final imageUrl = await _apiService.uploadImage(profileImageFile.value!);
        // updatedUser.avatar = imageUrl;
      }
      
      // Update user profile via API
      final response = await _apiService.put(
        '/users/${user.value!.id}',
        data: updatedUser.toJson(),
      );
      
      if (response.statusCode == 200) {
        // Update local storage
        await _storageService.saveUser(updatedUser);
        
        // Update user value
        user.value = updatedUser;
        
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        
        // Navigate back
        Get.back();
      } else {
        throw Exception('Failed to update profile: ${response.statusMessage}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdating.value = false;
    }
  }
}