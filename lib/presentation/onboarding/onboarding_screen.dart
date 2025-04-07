import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants/dimension_constants.dart';
import '../../core/constants/animation_constants.dart';
import '../../widgets/animated_fade_in.dart';
import '../../widgets/custom_button.dart';
import 'onboarding_controller.dart';
import 'widgets/onboarding_page.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                physics: const BouncingScrollPhysics(),
                children: [
                  OnboardingPage(
                    title: 'Discover Unique Products',
                    description:
                        'Explore a wide range of products from multiple vendors all in one place.',
                    imagePath: 'assets/images/onboarding_1.png',
                    animationDuration: const Duration(
                        milliseconds: AnimationConstants.defaultDuration),
                  ),
                  OnboardingPage(
                    title: 'Easy Shopping Experience',
                    description:
                        'Enjoy a seamless shopping experience with intuitive navigation and quick checkout.',
                    imagePath: 'assets/images/onboarding_2.png',
                    animationDuration: const Duration(
                        milliseconds: AnimationConstants.defaultDuration),
                  ),
                  OnboardingPage(
                    title: 'Fast & Secure Delivery',
                    description:
                        'Get your orders delivered quickly and securely right to your doorstep.',
                    imagePath: 'assets/images/onboarding_3.png',
                    animationDuration: const Duration(
                        milliseconds: AnimationConstants.defaultDuration),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(DimensionConstants.paddingL),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: controller.pageController,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Theme.of(context).colorScheme.primary,
                      dotColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 4,
                      spacing: 6,
                    ),
                  ),
                  const SizedBox(height: DimensionConstants.marginXL),
                  Obx(() => AnimatedFadeIn(
                        child: CustomButton(
                          text: controller.isLastPage.value ? 'Get Started' : 'Next',
                          icon: controller.isLastPage.value
                              ? Icons.arrow_forward
                              : null,
                          onPressed: controller.isLastPage.value
                              ? controller.onGetStarted
                              : controller.onNext,
                          isFullWidth: true,
                        ),
                      )),
                  const SizedBox(height: DimensionConstants.marginM),
                  Obx(() => Visibility(
                        visible: !controller.isLastPage.value,
                        child: AnimatedFadeIn(
                          child: TextButton(
                            onPressed: controller.onSkip,
                            child: const Text('Skip'),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: DimensionConstants.paddingM,
                                  horizontal: DimensionConstants.paddingXL),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
