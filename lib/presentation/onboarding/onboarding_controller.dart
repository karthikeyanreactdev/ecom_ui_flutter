import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;
  final isLastPage = false.obs;
  
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
  
  void onPageChanged(int page) {
    currentPage.value = page;
    isLastPage.value = page == 2; // Last page (0-indexed, so 2 is the third page)
  }
  
  void onNext() {
    // Animate to next page
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
  
  void onSkip() {
    // Go directly to the last page
    pageController.animateToPage(
      2, // Last page index
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
  
  void onGetStarted() {
    // Navigate to login screen
    Get.offAllNamed(AppRoutes.login);
  }
}
