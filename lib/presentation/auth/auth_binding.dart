import 'package:get/get.dart';
import 'login/login_controller.dart';
import 'register/register_controller.dart';
import 'forgot_password/forgot_password_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(
      LoginController(),
    );
    Get.put<RegisterController>(
      RegisterController(),
    );
    Get.put<ForgotPasswordController>(
      ForgotPasswordController(),
    );
  }
}
