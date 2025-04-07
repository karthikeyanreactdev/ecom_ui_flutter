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
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<CategoriesController>(() => CategoriesController(), fenix: true);
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
