import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/cart_item_model.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/dimension_constants.dart';

class OrderItemList extends StatelessWidget {
  final List<CartItemModel> items;

  const OrderItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildOrderItem(item);
      },
    );
  }

  Widget _buildOrderItem(CartItemModel item) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$');
    final actualPrice = item.product.price * item.quantity;
    final discountedPrice =
        item.discountedPrice != null
            ? item.discountedPrice! * item.quantity
            : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DimensionConstants.radiusS),
              image: DecorationImage(
                image: NetworkImage(item.product.images.first),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: DimensionConstants.spacingM),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Variants (if any)
                if (item.color != null || item.size != null) ...[
                  Row(
                    children: [
                      if (item.color != null) ...[
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Color(
                              int.parse('0xFF${item.color!.substring(1)}'),
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.color!,
                          style: TextStyle(
                            color: ColorConstants.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],

                      if (item.size != null) ...[
                        const Icon(
                          Icons.straighten,
                          size: 12,
                          color: ColorConstants.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.size!,
                          style: TextStyle(
                            color: ColorConstants.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                ],

                // Quantity
                Text(
                  'Qty: ${item.quantity}',
                  style: const TextStyle(
                    color: ColorConstants.textSecondary,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                // Price
                Row(
                  children: [
                    if (discountedPrice != null) ...[
                      Text(
                        currencyFormatter.format(discountedPrice),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: ColorConstants.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        currencyFormatter.format(actualPrice),
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: ColorConstants.textTertiary,
                          fontSize: 14,
                        ),
                      ),
                    ] else ...[
                      Text(
                        currencyFormatter.format(actualPrice),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: ColorConstants.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
