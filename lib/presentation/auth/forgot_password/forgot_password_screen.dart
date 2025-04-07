import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/constants/dimension_constants.dart';
import '../../../widgets/animated_fade_in.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(TextConstants.resetPassword),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DimensionConstants.paddingL),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: DimensionConstants.marginL),
                
                // Instructions text
                AnimatedFadeIn(
                  child: Text(
                    TextConstants.resetPasswordInstructions,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                
                const SizedBox(height: DimensionConstants.marginXL),
                
                // Email field
                AnimatedFadeIn(
                  delay: const Duration(milliseconds: 100),
                  child: CustomTextField(
                    controller: controller.emailController,
                    label: TextConstants.email,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: controller.validateEmail,
                  ),
                ),
                
                const SizedBox(height: DimensionConstants.marginXL),
                
                // Send reset link button
                AnimatedFadeIn(
                  delay: const Duration(milliseconds: 200),
                  child: Obx(() => CustomButton(
                    text: TextConstants.sendResetLink,
                    onPressed: controller.onSendLinkPressed,
                    isLoading: controller.isLoading.value,
                    isFullWidth: true,
                  )),
                ),
                
                const SizedBox(height: DimensionConstants.marginL),
                
                // Back to login button
                AnimatedFadeIn(
                  delay: const Duration(milliseconds: 300),
                  child: Center(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text(TextConstants.backToLogin),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
