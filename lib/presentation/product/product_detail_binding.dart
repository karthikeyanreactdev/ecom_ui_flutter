import 'package:get/get.dart';
import 'product_detail_controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProductDetailController>(ProductDetailController());
  }
}
