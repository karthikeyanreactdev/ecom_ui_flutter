import 'package:get/get.dart';
import 'cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CartController>(CartController());
  }
}
