import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../core/constants/color_constants.dart';
import '../core/constants/dimension_constants.dart';

class CustomShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const CustomShimmer({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = DimensionConstants.radiusS,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor:
          isDarkMode
              ? ColorConstants.shimmerBaseColorDark
              : ColorConstants.shimmerBaseLight,
      highlightColor:
          isDarkMode
              ? ColorConstants.shimmerHighlightColorDark
              : ColorConstants.shimmerHighlightLight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDarkMode ? ColorConstants.cardDark : ColorConstants.cardLight;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          CustomShimmer(
            width: double.infinity,
            height: 180,
            borderRadius: DimensionConstants.radiusM,
          ),
          const SizedBox(height: DimensionConstants.marginM),

          // Content placeholders
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DimensionConstants.paddingM,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShimmer(
                  width: 120,
                  height: 12,
                  borderRadius: DimensionConstants.radiusXS,
                ),
                const SizedBox(height: DimensionConstants.marginS),

                CustomShimmer(
                  width: double.infinity,
                  height: 16,
                  borderRadius: DimensionConstants.radiusXS,
                ),
                const SizedBox(height: DimensionConstants.marginXS),

                CustomShimmer(
                  width: 100,
                  height: 16,
                  borderRadius: DimensionConstants.radiusXS,
                ),
                const SizedBox(height: DimensionConstants.marginM),

                CustomShimmer(
                  width: 80,
                  height: 22,
                  borderRadius: DimensionConstants.radiusXS,
                ),
                const SizedBox(height: DimensionConstants.marginL),

                CustomShimmer(
                  width: double.infinity,
                  height: 36,
                  borderRadius: DimensionConstants.radiusS,
                ),
                const SizedBox(height: DimensionConstants.marginM),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BannerShimmer extends StatelessWidget {
  final double height;

  const BannerShimmer({Key? key, this.height = DimensionConstants.bannerHeight})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomShimmer(
          width: double.infinity,
          height: height,
          borderRadius: DimensionConstants.radiusM,
        ),
        const SizedBox(height: DimensionConstants.marginM),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DimensionConstants.paddingXS,
              ),
              child: CustomShimmer(
                width: 8,
                height: 8,
                borderRadius: DimensionConstants.radiusCircular,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDarkMode ? ColorConstants.cardDark : ColorConstants.cardLight;

    return Container(
      width: DimensionConstants.categoryImageSize * 1.5,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: DimensionConstants.marginM),
          CustomShimmer(
            width: DimensionConstants.categoryImageSize,
            height: DimensionConstants.categoryImageSize,
            borderRadius: DimensionConstants.radiusS,
          ),
          const SizedBox(height: DimensionConstants.marginM),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DimensionConstants.paddingS,
            ),
            child: CustomShimmer(
              width: 60,
              height: 12,
              borderRadius: DimensionConstants.radiusXS,
            ),
          ),
          const SizedBox(height: DimensionConstants.marginM),
        ],
      ),
    );
  }
}
