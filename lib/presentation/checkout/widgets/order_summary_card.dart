import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';

class OrderSummaryCard extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final double tax;
  final double discount;
  final double total;

  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.discount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DimensionConstants.paddingM),
        child: Column(
          children: [
            _buildSummaryRow('Subtotal', currencyFormatter.format(subtotal)),
            const SizedBox(height: 8),
            _buildSummaryRow('Shipping', currencyFormatter.format(shipping)),
            const SizedBox(height: 8),
            _buildSummaryRow('Tax', currencyFormatter.format(tax)),
            if (discount > 0) ...[
              const SizedBox(height: 8),
              _buildSummaryRow(
                'Discount',
                '- ${currencyFormatter.format(discount)}',
                valueColor: ColorConstants.success,
              ),
            ],
            const Divider(height: 24),
            _buildSummaryRow(
              'Total',
              currencyFormatter.format(total),
              titleStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              valueStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: ColorConstants.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String title,
    String value, {
    TextStyle? titleStyle,
    TextStyle? valueStyle,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: titleStyle ?? const TextStyle(fontSize: 16)),
        Text(
          value,
          style:
              valueStyle ??
              TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
        ),
      ],
    );
  }
}
