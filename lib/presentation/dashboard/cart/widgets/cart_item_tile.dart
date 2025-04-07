import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/dimension_constants.dart';
import '../../../../data/models/cart_item_model.dart';
import '../../../../routes/app_routes.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onIncreaseQuantity;
  final VoidCallback onDecreaseQuantity;
  final VoidCallback onRemove;

  const CartItemTile({
    Key? key,
    required this.item,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
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

    return Container(
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
      child: InkWell(
        onTap:
            () => Get.toNamed(AppRoutes.productDetail, arguments: item.product),
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(DimensionConstants.paddingM),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(DimensionConstants.radiusS),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child:
                      item.product.images.isNotEmpty
                          ? Image.network(
                            item.product.images[0],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color:
                                    isDarkMode
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade200,
                                child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                          : Container(
                            color:
                                isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey,
                            ),
                          ),
                ),
              ),

              const SizedBox(width: DimensionConstants.marginM),

              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      item.product.name,
                      style: TextStyle(
                        fontSize: DimensionConstants.textM,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: DimensionConstants.marginXS),

                    // Variant info (color, size)
                    if (item.color != null || item.size != null)
                      Text(
                        [
                          if (item.color != null) 'Color: ${item.color}',
                          if (item.size != null) 'Size: ${item.size}',
                        ].join(', '),
                        style: TextStyle(
                          fontSize: DimensionConstants.textXS,
                          color: secondaryTextColor,
                        ),
                      ),

                    const SizedBox(height: DimensionConstants.marginS),

                    // Price
                    Text(
                      '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: DimensionConstants.textL,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),

                    if (item.product.isOnSale) ...[
                      const SizedBox(height: 2),
                      Text(
                        '\$${(item.product.compareAtPrice! * item.quantity).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: DimensionConstants.textS,
                          decoration: TextDecoration.lineThrough,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],

                    const SizedBox(height: DimensionConstants.marginM),

                    // Actions row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Quantity selector
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              DimensionConstants.radiusS,
                            ),
                            border: Border.all(
                              color:
                                  isDarkMode
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Decrease button
                              InkWell(
                                onTap:
                                    item.quantity > 1
                                        ? onDecreaseQuantity
                                        : null,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(
                                        DimensionConstants.radiusS,
                                      ),
                                      bottomLeft: Radius.circular(
                                        DimensionConstants.radiusS,
                                      ),
                                    ),
                                    color:
                                        item.quantity > 1
                                            ? (isDarkMode
                                                ? Colors.grey.shade800
                                                : Colors.grey.shade100)
                                            : (isDarkMode
                                                ? Colors.grey.shade900
                                                : Colors.grey.shade200),
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    size: 16,
                                    color:
                                        item.quantity > 1
                                            ? textColor
                                            : isDarkMode
                                            ? Colors.grey.shade700
                                            : Colors.grey.shade400,
                                  ),
                                ),
                              ),

                              // Quantity display
                              Container(
                                width: 40,
                                height: 32,
                                alignment: Alignment.center,
                                color:
                                    isDarkMode ? Colors.black12 : Colors.white,
                                child: Text(
                                  item.quantity.toString(),
                                  style: TextStyle(
                                    fontSize: DimensionConstants.textS,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ),

                              // Increase button
                              InkWell(
                                onTap:
                                    item.quantity < item.product.quantity
                                        ? onIncreaseQuantity
                                        : null,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(
                                        DimensionConstants.radiusS,
                                      ),
                                      bottomRight: Radius.circular(
                                        DimensionConstants.radiusS,
                                      ),
                                    ),
                                    color:
                                        item.quantity < item.product.quantity
                                            ? (isDarkMode
                                                ? Colors.grey.shade800
                                                : Colors.grey.shade100)
                                            : (isDarkMode
                                                ? Colors.grey.shade900
                                                : Colors.grey.shade200),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 16,
                                    color:
                                        item.quantity < item.product.quantity
                                            ? textColor
                                            : isDarkMode
                                            ? Colors.grey.shade700
                                            : Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Remove button
                        InkWell(
                          onTap: onRemove,
                          borderRadius: BorderRadius.circular(
                            DimensionConstants.radiusXS,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.delete_outline,
                              color:
                                  isDarkMode
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade700,
                              size: DimensionConstants.iconS,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
