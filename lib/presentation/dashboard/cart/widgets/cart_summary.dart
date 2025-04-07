import 'package:flutter/material.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/dimension_constants.dart';

class CartSummary extends StatelessWidget {
  final double subtotal;
  final double shippingCost;
  final double tax;
  final double discount;
  final double total;

  const CartSummary({
    Key? key,
    required this.subtotal,
    required this.shippingCost,
    required this.tax,
    required this.discount,
    required this.total,
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
    final dividerColor =
        isDarkMode ? ColorConstants.dividerDark : ColorConstants.dividerLight;

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
            'Order Summary',
            style: TextStyle(
              fontSize: DimensionConstants.textL,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: DimensionConstants.marginL),

          // Subtotal
          _buildSummaryRow(
            label: 'Subtotal',
            value: '\$${subtotal.toStringAsFixed(2)}',
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
          ),

          const SizedBox(height: DimensionConstants.marginM),

          // Shipping cost
          _buildSummaryRow(
            label: 'Shipping',
            value:
                shippingCost > 0
                    ? '\$${shippingCost.toStringAsFixed(2)}'
                    : 'Free',
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
            valueColor: shippingCost > 0 ? null : ColorConstants.success,
          ),

          const SizedBox(height: DimensionConstants.marginM),

          // Tax
          _buildSummaryRow(
            label: 'Tax (8%)',
            value: '\$${tax.toStringAsFixed(2)}',
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
          ),

          // Discount if applied
          if (discount > 0) ...[
            const SizedBox(height: DimensionConstants.marginM),
            _buildSummaryRow(
              label: 'Discount',
              value: '-\$${discount.toStringAsFixed(2)}',
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              valueColor: ColorConstants.success,
            ),
          ],

          const SizedBox(height: DimensionConstants.marginM),
          Divider(color: dividerColor),
          const SizedBox(height: DimensionConstants.marginM),

          // Total
          _buildSummaryRow(
            label: 'Total',
            value: '\$${total.toStringAsFixed(2)}',
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    required Color textColor,
    required Color secondaryTextColor,
    Color? valueColor,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize:
                isTotal ? DimensionConstants.textL : DimensionConstants.textM,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? textColor : secondaryTextColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize:
                isTotal ? DimensionConstants.textL : DimensionConstants.textM,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: valueColor ?? (isTotal ? textColor : secondaryTextColor),
          ),
        ),
      ],
    );
  }
}
