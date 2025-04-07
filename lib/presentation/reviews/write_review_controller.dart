import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../services/api_service.dart';

class WriteReviewController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  final TextEditingController titleController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();
  
  final RxDouble rating = 5.0.obs;
  final RxList<File> selectedImages = <File>[].obs;
  final RxBool isSubmitting = false.obs;
  
  final ImagePicker _imagePicker = ImagePicker();
  
  @override
  void onClose() {
    titleController.dispose();
    reviewController.dispose();
    super.onClose();
  }
  
  Future<void> pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        // Limit to 5 images
        if (selectedImages.length < 5) {
          selectedImages.add(File(image.path));
        } else {
          Get.snackbar(
            'Limit Reached',
            'You can only add up to 5 images',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  void removeImage(File image) {
    selectedImages.remove(image);
  }
  
  Future<void> submitReview(String productId) async {
    if (titleController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please provide a review title',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    if (reviewController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please write your review',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    isSubmitting.value = true;
    
    try {
      // In a real app, you would upload images and get URLs
      final List<String> imageUrls = [];
      
      // Simulate image upload delay
      if (selectedImages.isNotEmpty) {
        await Future.delayed(const Duration(seconds: 1));
        
        // Mock image URLs
        for (var i = 0; i < selectedImages.length; i++) {
          imageUrls.add('https://example.com/review-image-${i + 1}.jpg');
        }
      }
      
      // Create review data
      final reviewData = {
        'id': const Uuid().v4(),
        'productId': productId,
        'title': titleController.text,
        'content': reviewController.text,
        'rating': rating.value,
        'images': imageUrls,
        'createdAt': DateTime.now().toIso8601String(),
      };
      
      // In a real app, you would send this to your API
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      Get.back(result: true);
      Get.snackbar(
        'Success',
        'Your review has been submitted. Thank you for your feedback!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit review: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}