import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';

class SortBottomSheet extends StatelessWidget {
  final String currentSortOption;
  final Function(String) onSortOptionSelected;

  const SortBottomSheet({
    Key? key,
    required this.currentSortOption,
    required this.onSortOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? ColorConstants.cardDark : ColorConstants.cardLight;
    final textColor =
        isDarkMode
            ? ColorConstants.textPrimaryDark
            : ColorConstants.textPrimaryLight;
    final secondaryTextColor =
        isDarkMode
            ? ColorConstants.textSecondaryDark
            : ColorConstants.textSecondaryLight;
    final dividerColor =
        isDarkMode ? ColorConstants.dividerDark : ColorConstants.dividerLight;

    return Container(
      padding: const EdgeInsets.only(
        top: DimensionConstants.paddingL,
        bottom: DimensionConstants.paddingXL,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(DimensionConstants.radiusXL),
          topRight: Radius.circular(DimensionConstants.radiusXL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: DimensionConstants.marginL),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DimensionConstants.paddingL,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: DimensionConstants.textXL,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close, color: secondaryTextColor),
                ),
              ],
            ),
          ),

          const SizedBox(height: DimensionConstants.marginM),
          const Divider(),

          // Sort options
          _buildSortOption(
            context: context,
            title: 'Newest',
            value: 'newest',
            isSelected: currentSortOption == 'newest',
            onSelected: () {
              HapticFeedback.selectionClick();
              onSortOptionSelected('newest');
              Get.back();
            },
            dividerColor: dividerColor,
            textColor: textColor,
          ),

          _buildSortOption(
            context: context,
            title: 'Price: Low to High',
            value: 'price-low-high',
            isSelected: currentSortOption == 'price-low-high',
            onSelected: () {
              HapticFeedback.selectionClick();
              onSortOptionSelected('price-low-high');
              Get.back();
            },
            dividerColor: dividerColor,
            textColor: textColor,
          ),

          _buildSortOption(
            context: context,
            title: 'Price: High to Low',
            value: 'price-high-low',
            isSelected: currentSortOption == 'price-high-low',
            onSelected: () {
              HapticFeedback.selectionClick();
              onSortOptionSelected('price-high-low');
              Get.back();
            },
            dividerColor: dividerColor,
            textColor: textColor,
          ),

          _buildSortOption(
            context: context,
            title: 'Popularity',
            value: 'popularity',
            isSelected: currentSortOption == 'popularity',
            onSelected: () {
              HapticFeedback.selectionClick();
              onSortOptionSelected('popularity');
              Get.back();
            },
            dividerColor: dividerColor,
            textColor: textColor,
          ),

          _buildSortOption(
            context: context,
            title: 'Rating',
            value: 'rating',
            isSelected: currentSortOption == 'rating',
            onSelected: () {
              HapticFeedback.selectionClick();
              onSortOptionSelected('rating');
              Get.back();
            },
            dividerColor: dividerColor,
            textColor: textColor,
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSortOption({
    required BuildContext context,
    required String title,
    required String value,
    required bool isSelected,
    required VoidCallback onSelected,
    required Color dividerColor,
    required Color textColor,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onSelected,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DimensionConstants.paddingL,
              vertical: DimensionConstants.paddingM,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: DimensionConstants.textM,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? ColorConstants.primary : textColor,
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check, color: ColorConstants.primary),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            color: dividerColor,
            height: 1,
            indent: DimensionConstants.paddingL,
            endIndent: DimensionConstants.paddingL,
          ),
      ],
    );
  }
}
