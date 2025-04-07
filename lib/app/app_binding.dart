import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../services/connectivity_service.dart';
import '../theme/theme_service.dart';
import '../theme/theme_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Register Services
    Get.put<StorageService>(StorageService(), permanent: true);
    Get.put<ConnectivityService>(ConnectivityService(), permanent: true);
    Get.put<ThemeService>(ThemeService(), permanent: true);
    Get.put<ApiService>(ApiService(Get.find<StorageService>()), permanent: true);
    
    // Register Controllers
    Get.put<ThemeController>(ThemeController(), permanent: true);
  }
}
