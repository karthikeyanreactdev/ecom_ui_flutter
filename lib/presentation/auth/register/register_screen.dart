import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/constants/dimension_constants.dart';
import '../../../widgets/animated_fade_in.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../routes/app_routes.dart';
import 'register_controller.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(TextConstants.createAccount),
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
                // Name field
                AnimatedFadeIn(
                  child: CustomTextField(
                    controller: controller.nameController,
                    label: 'Full Name',
                    keyboardType: TextInputType.name,
                    prefixIcon: Icons.person_outline,
                    validator: controller.validateName,
                  ),
                ),
                
                const SizedBox(height: DimensionConstants.marginL),
                
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
                
                const SizedBox(height: DimensionConstants.marginL),
                
                // Phone field
                AnimatedFadeIn(
                  delay: const Duration(milliseconds: 200),
                  child: CustomTextField(
                    controller: controller.phoneController,
                    label: TextConstants.phoneNumber,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    validator: controller.validatePhone,
                  ),
                ),
                
                const SizedBox(height: DimensionConstants.marginL),
                
                // Password field
                AnimatedFadeIn(
                  delay: const Duration(milliseconds: 300),
                  child: Obx(() => CustomTextField(
                    controller: controller.passwordController,
                    label: TextConstants.password,
                    prefixIcon: Icons.lock_outline,
                    obscureText: !controller.passwordVisible.value,
                    validator: controller.validatePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.passwordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: colorScheme.primary,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  )),
                ),
                
                const SizedBox(height: DimensionConstants.marginL),
                
                // Confirm password field
                AnimatedFadeIn(
                  delay: const Duration(milliseconds: 400),
                  child: Obx(() => CustomTextField(
                    controller: controller.confirmPasswordController,
                    label: TextConstants.confirmPassword,
                    prefixIcon: Icons.lock_outline,
                    obscureText: !controller.confirmPasswordVisible.value,
                    validator: controller.validateConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.confirmPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: colorScheme.primary,
                      ),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                  )),
                ),
                
                const SizedBox(height: DimensionConstants.marginXL),
                
                // Register button
                AnimatedFadeIn(
                  delay: const Duration(milliseconds: 500),
                  child: Obx(() => CustomButton(
                    text: TextConstants.register,
                    onPressed: controller.onRegisterPressed,
                    isLoading: controller.isLoading.value,
                    isFullWidth: true,
                  )),
                ),
                
                const SizedBox(height: DimensionConstants.marginL),
                
                // Login link
                AnimatedFadeIn(
                  delay: const Duration(milliseconds: 600),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        TextConstants.alreadyHaveAccount,
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () => Get.offNamed(AppRoutes.login),
                        child: Text(TextConstants.login),
                      ),
                    ],
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
