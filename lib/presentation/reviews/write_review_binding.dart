import 'package:get/get.dart';
import 'write_review_controller.dart';

class WriteReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<WriteReviewController>(WriteReviewController());
  }
}
