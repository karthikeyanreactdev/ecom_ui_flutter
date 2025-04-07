import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    print("ass");

    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    // Simulate loading for demonstration (you'd typically do actual initialization here)
    await Future.delayed(const Duration(seconds: 2));

    // Check if first launch
    bool isFirstLaunch = await _storageService.isFirstLaunch();

    if (isFirstLaunch) {
      // Set first launch to false for subsequent app opens
      await _storageService.setFirstLaunch(false);
      // Navigate to onboarding
      Get.offAllNamed(AppRoutes.onboarding);
    } else {
      // Check if user is logged in
      bool isLoggedIn = await _storageService.isLoggedIn();

      if (isLoggedIn) {
        // Navigate to home screen
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        // Navigate to login screen
        Get.offAllNamed(AppRoutes.login);
      }
    }
  }
}
