import 'package:flutter/material.dart';
import '../../../core/constants/dimension_constants.dart';
import '../../../widgets/animated_fade_in.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final Duration animationDuration;

  const OnboardingPage({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.animationDuration = const Duration(milliseconds: 400),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(DimensionConstants.paddingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image with fade and scale animation
          Expanded(
            flex: 6,
            child: AnimatedFadeIn(
              duration: animationDuration,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if image is not available
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(DimensionConstants.radiusL),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: DimensionConstants.marginXL),
          // Title with fade and slide animation
          AnimatedFadeIn(
            duration: animationDuration,
            delay: const Duration(milliseconds: 150),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: DimensionConstants.marginL),
          // Description with fade and slide animation
          AnimatedFadeIn(
            duration: animationDuration,
            delay: const Duration(milliseconds: 300),
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: DimensionConstants.marginXXL),
        ],
      ),
    );
  }
}
