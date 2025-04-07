import 'package:get/get.dart';
import 'payment_method_controller.dart';

class PaymentMethodBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PaymentMethodController>(PaymentMethodController());
  }
}
