import 'package:get/get.dart';
import 'checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CheckoutController>(CheckoutController());
  }
}
