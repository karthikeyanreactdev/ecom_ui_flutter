import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/constants/assets_constants.dart';
import '../../../core/constants/dimension_constants.dart';
import '../../../widgets/animated_fade_in.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../routes/app_routes.dart';
import 'login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DimensionConstants.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: DimensionConstants.marginXL),
              
              // Logo
              Center(
                child: Hero(
                  tag: 'app_logo',
                  child: Image.asset(
                    Get.isDarkMode ? AssetConstants.logoDark : AssetConstants.logoLight,
                    width: 100,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if logo image is not available
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            TextConstants.appName[0],
                            style: theme.textTheme.displayMedium?.copyWith(
                                  color: Colors.white,
                                  fontSize: 40,
                                ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: DimensionConstants.marginXL),
              
              // Welcome back text
              AnimatedFadeIn(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  TextConstants.welcomeBack,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: DimensionConstants.marginS),
              
              // Sign in to continue text
              AnimatedFadeIn(
                delay: const Duration(milliseconds: 300),
                child: Text(
                  TextConstants.signInToContinue,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                  ),
                ),
              ),
              
              const SizedBox(height: DimensionConstants.marginXL),
              
              // Email field
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    AnimatedFadeIn(
                      delay: const Duration(milliseconds: 400),
                      child: CustomTextField(
                        controller: controller.emailController,
                        label: TextConstants.email,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: controller.validateEmail,
                      ),
                    ),
                    
                    const SizedBox(height: DimensionConstants.marginL),
                    
                    // Password field
                    AnimatedFadeIn(
                      delay: const Duration(milliseconds: 500),
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
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: DimensionConstants.marginS),
                    
                    // Forgot password button
                    AnimatedFadeIn(
                      delay: const Duration(milliseconds: 600),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () =>
                              Get.toNamed(AppRoutes.forgotPassword),
                          child: Text(TextConstants.forgotPassword),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: DimensionConstants.paddingS,
                                horizontal: DimensionConstants.paddingM),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: DimensionConstants.marginXL),
                    
                    // Login button
                    AnimatedFadeIn(
                      delay: const Duration(milliseconds: 700),
                      child: Obx(() => CustomButton(
                          text: TextConstants.login,
                          onPressed: controller.onLoginPressed,
                          isLoading: controller.isLoading.value,
                          isFullWidth: true,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: DimensionConstants.marginXL),
                    
                    // Sign up link
                    AnimatedFadeIn(
                      delay: const Duration(milliseconds: 800),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            TextConstants.dontHaveAccount,
                            style: theme.textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () => Get.toNamed(AppRoutes.register),
                            child: Text(TextConstants.register),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
