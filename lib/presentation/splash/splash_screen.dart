import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/text_constants.dart';
import '../../core/constants/assets_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../core/constants/animation_constants.dart';
import 'splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Animation
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(
                  milliseconds: AnimationConstants.logoAnimationDuration),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: Hero(
                tag: 'app_logo',
                child: Image.asset(
                  Get.isDarkMode ? AssetConstants.logoDark : AssetConstants.logoLight,
                  width: 150,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if logo image is not available
                    return Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          TextConstants.appName[0],
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 60,
                              ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: DimensionConstants.marginXXL),
            // App Name Animation
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(
                  milliseconds: AnimationConstants.logoAnimationDuration),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Text(
                TextConstants.appName,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
              ),
            ),
            const SizedBox(height: DimensionConstants.marginL),
            // Loading indicator
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(
                  milliseconds: AnimationConstants.logoAnimationDuration),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: child,
                );
              },
              child: SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
