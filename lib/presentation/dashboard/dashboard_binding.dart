import 'package:get/get.dart';
import 'dashboard_controller.dart';
import 'home/home_controller.dart';
import 'categories/categories_controller.dart';
import 'cart/cart_controller.dart';
import 'profile/profile_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Dashboard controller
    Get.put<DashboardController>(DashboardController());

    // Tab controllers - lazy loaded
    Get.put<HomeController>(
      HomeController(),
    );
    Get.put<CategoriesController>(
      CategoriesController(),
    );
    Get.put<CartController>(
      CartController(),
    );
    Get.put<ProfileController>(
      ProfileController(),
    );
  }
}
