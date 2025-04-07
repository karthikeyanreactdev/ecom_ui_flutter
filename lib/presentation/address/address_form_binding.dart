import 'package:get/get.dart';
import 'address_form_controller.dart';

class AddressFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressFormController>(() => AddressFormController());
  }
}