import 'package:flutter/material.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/dimension_constants.dart';

class ShippingOptions extends StatelessWidget {
  final String selectedOption;
  final Function(String) onOptionSelected;
  final double freeShippingThreshold;
  final double currentSubtotal;

  const ShippingOptions({
    Key? key,
    required this.selectedOption,
    required this.onOptionSelected,
    required this.freeShippingThreshold,
    required this.currentSubtotal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode
            ? ColorConstants.textPrimaryDark
            : ColorConstants.textPrimaryLight;
    final secondaryTextColor =
        isDarkMode
            ? ColorConstants.textSecondaryDark
            : ColorConstants.textSecondaryLight;
    final cardColor =
        isDarkMode ? ColorConstants.cardDark : ColorConstants.cardLight;

    // Check if free shipping is available
    final bool isFreeShipping = currentSubtotal >= freeShippingThreshold;

    return Container(
      padding: const EdgeInsets.all(DimensionConstants.paddingL),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Text(
                'Shipping',
                style: TextStyle(
                  fontSize: DimensionConstants.textL,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const Spacer(),

              // Free shipping notice
              if (isFreeShipping)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DimensionConstants.paddingS,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorConstants.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      DimensionConstants.radiusXS,
                    ),
                  ),
                  child: const Text(
                    'Free Shipping Available',
                    style: TextStyle(
                      fontSize: DimensionConstants.textXS,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.success,
                    ),
                  ),
                ),
            ],
          ),

          // Free shipping progress
          if (!isFreeShipping) ...[
            const SizedBox(height: DimensionConstants.marginM),
            LinearProgressIndicator(
              value: currentSubtotal / freeShippingThreshold,
              backgroundColor:
                  isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
              color: ColorConstants.primary,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: DimensionConstants.marginS),
            Text(
              'Add \$${(freeShippingThreshold - currentSubtotal).toStringAsFixed(2)} more for free shipping',
              style: TextStyle(
                fontSize: DimensionConstants.textXS,
                color: secondaryTextColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],

          const SizedBox(height: DimensionConstants.marginL),

          // Shipping options
          _buildShippingOption(
            context: context,
            label: 'Standard Shipping',
            description: '3-5 business days',
            value: 'standard',
            cost: isFreeShipping ? 0.0 : 5.99,
            isSelected: selectedOption == 'standard',
            onSelected: () => onOptionSelected('standard'),
          ),

          const SizedBox(height: DimensionConstants.marginM),

          _buildShippingOption(
            context: context,
            label: 'Express Shipping',
            description: '2-3 business days',
            value: 'express',
            cost: 12.99,
            isSelected: selectedOption == 'express',
            onSelected: () => onOptionSelected('express'),
          ),

          const SizedBox(height: DimensionConstants.marginM),

          _buildShippingOption(
            context: context,
            label: 'Overnight Shipping',
            description: 'Next business day',
            value: 'overnight',
            cost: 19.99,
            isSelected: selectedOption == 'overnight',
            onSelected: () => onOptionSelected('overnight'),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingOption({
    required BuildContext context,
    required String label,
    required String description,
    required String value,
    required double cost,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode
            ? ColorConstants.textPrimaryDark
            : ColorConstants.textPrimaryLight;
    final secondaryTextColor =
        isDarkMode
            ? ColorConstants.textSecondaryDark
            : ColorConstants.textSecondaryLight;

    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(DimensionConstants.radiusS),
      child: Container(
        padding: const EdgeInsets.all(DimensionConstants.paddingM),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusS),
          border: Border.all(
            color:
                isSelected
                    ? ColorConstants.primary
                    : isDarkMode
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color:
              isSelected
                  ? ColorConstants.primary.withOpacity(0.05)
                  : Colors.transparent,
        ),
        child: Row(
          children: [
            // Radio button
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected
                          ? ColorConstants.primary
                          : isDarkMode
                          ? Colors.grey.shade600
                          : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child:
                  isSelected
                      ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorConstants.primary,
                          ),
                        ),
                      )
                      : null,
            ),

            const SizedBox(width: DimensionConstants.marginM),

            // Option details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: DimensionConstants.textM,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: DimensionConstants.textXS,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),

            // Cost
            Text(
              cost > 0 ? '\$${cost.toStringAsFixed(2)}' : 'Free',
              style: TextStyle(
                fontSize: DimensionConstants.textM,
                fontWeight: FontWeight.w500,
                color: cost > 0 ? textColor : ColorConstants.success,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
