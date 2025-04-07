import 'package:get/get.dart';
import 'payment_form_controller.dart';

class PaymentFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PaymentFormController>(PaymentFormController());
  }
}
