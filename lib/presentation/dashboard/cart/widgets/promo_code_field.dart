import 'package:flutter/material.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/dimension_constants.dart';

class PromoCodeField extends StatelessWidget {
  final TextEditingController controller;
  final bool isValid;
  final bool isLoading;
  final VoidCallback onApply;
  final VoidCallback onRemove;

  const PromoCodeField({
    Key? key,
    required this.controller,
    required this.isValid,
    required this.isLoading,
    required this.onApply,
    required this.onRemove,
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
    final inputBackground = isDarkMode ? Colors.black12 : Colors.grey.shade100;

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
          Text(
            'Promo Code',
            style: TextStyle(
              fontSize: DimensionConstants.textL,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: DimensionConstants.marginM),

          // Input field
          isValid
              ? _buildAppliedPromo(context)
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text field
                  Expanded(
                    child: TextField(
                      controller: controller,
                      style: TextStyle(
                        fontSize: DimensionConstants.textM,
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter promo code',
                        hintStyle: TextStyle(
                          color: secondaryTextColor,
                          fontSize: DimensionConstants.textM,
                        ),
                        filled: true,
                        fillColor: inputBackground,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: DimensionConstants.paddingL,
                          vertical: DimensionConstants.paddingM,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            DimensionConstants.radiusS,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon:
                            controller.text.isNotEmpty
                                ? IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: () {
                                    controller.clear();
                                  },
                                )
                                : null,
                      ),
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => onApply(),
                    ),
                  ),

                  const SizedBox(width: DimensionConstants.marginM),

                  // Apply button
                  SizedBox(
                    height: 50, // Match TextField height
                    child: ElevatedButton(
                      onPressed: controller.text.isNotEmpty ? onApply : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            DimensionConstants.radiusS,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: DimensionConstants.paddingL,
                        ),
                        disabledBackgroundColor:
                            isDarkMode
                                ? Colors.grey.shade800
                                : Colors.grey.shade300,
                        disabledForegroundColor:
                            isDarkMode
                                ? Colors.grey.shade600
                                : Colors.grey.shade500,
                      ),
                      child:
                          isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Apply'),
                    ),
                  ),
                ],
              ),

          // Promo code hint
          if (!isValid) ...[
            const SizedBox(height: DimensionConstants.marginS),
            Text(
              'Try "SAVE10" or "SAVE20" for discounts',
              style: TextStyle(
                fontSize: DimensionConstants.textXS,
                color: secondaryTextColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAppliedPromo(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final promoColor = ColorConstants.success;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DimensionConstants.paddingM,
        vertical: DimensionConstants.paddingM,
      ),
      decoration: BoxDecoration(
        color: promoColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DimensionConstants.radiusS),
        border: Border.all(color: promoColor, width: 1),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: ColorConstants.success,
            size: DimensionConstants.iconS,
          ),
          const SizedBox(width: DimensionConstants.marginS),

          // Promo code display
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.text.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.success,
                  ),
                ),
                const Text(
                  'Discount applied to your order',
                  style: TextStyle(
                    fontSize: DimensionConstants.textXS,
                    color: ColorConstants.success,
                  ),
                ),
              ],
            ),
          ),

          // Remove button
          IconButton(
            icon: Icon(
              Icons.close,
              color: isDarkMode ? Colors.white70 : Colors.black54,
              size: 18,
            ),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
