import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/color_constants.dart';
import '../core/constants/dimension_constants.dart';
import '../data/models/product_model.dart';
import '../routes/app_routes.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool showAddToCart;
  final VoidCallback? onAddToCart;
  final VoidCallback? onAddToWishlist;
  final bool isInWishlist;

  const ProductCard({
    Key? key,
    required this.product,
    this.showAddToCart = true,
    this.onAddToCart,
    this.onAddToWishlist,
    this.isInWishlist = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : ColorConstants.textPrimary;
    final secondaryTextColor = isDarkMode ? Colors.white70 : ColorConstants.textSecondary;
    final cardColor = isDarkMode ? ColorConstants.surfaceDark : ColorConstants.surfaceLight;

    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.productDetail,
        arguments: product,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product Image with Discount Tag and Wishlist Button
            Stack(
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(DimensionConstants.radiusM),
                    topRight: Radius.circular(DimensionConstants.radiusM),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1 / DimensionConstants.productImageRatio,
                    child: Image.network(
                      product.images[0],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Discount Tag
                if (product.isOnSale)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DimensionConstants.paddingS,
                        vertical: DimensionConstants.paddingXS,
                      ),
                      decoration: BoxDecoration(
                        color: ColorConstants.accent,
                        borderRadius: BorderRadius.circular(DimensionConstants.radiusXS),
                      ),
                      child: Text(
                        '-${product.discountPercentage.toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: DimensionConstants.textXS,
                        ),
                      ),
                    ),
                  ),
                
                // Wishlist Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onAddToWishlist,
                    child: Container(
                      padding: const EdgeInsets.all(DimensionConstants.paddingXS),
                      decoration: BoxDecoration(
                        color: cardColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isInWishlist ? Icons.favorite : Icons.favorite_border,
                        size: DimensionConstants.iconS,
                        color: isInWishlist ? ColorConstants.accent : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Product Details
            Padding(
              padding: const EdgeInsets.all(DimensionConstants.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand name if available
                  if (product.brand != null)
                    Text(
                      product.brand!,
                      style: TextStyle(
                        fontSize: DimensionConstants.textS,
                        color: secondaryTextColor,
                      ),
                    ),
                    
                  // Product Name
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: DimensionConstants.textM,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  
                  const SizedBox(height: DimensionConstants.marginS),
                  
                  // Rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: ColorConstants.accent,
                        size: DimensionConstants.iconXS,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toString(),
                        style: TextStyle(
                          fontSize: DimensionConstants.textS,
                          color: secondaryTextColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviewCount})',
                        style: TextStyle(
                          fontSize: DimensionConstants.textXS,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: DimensionConstants.marginS),
                  
                  // Price
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: DimensionConstants.textL,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      if (product.isOnSale) ...[
                        const SizedBox(width: DimensionConstants.marginS),
                        Text(
                          '\$${product.compareAtPrice!.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: DimensionConstants.textS,
                            fontWeight: FontWeight.w400,
                            color: secondaryTextColor,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  // Add to Cart Button
                  if (showAddToCart) ...[
                    const SizedBox(height: DimensionConstants.marginM),
                    GestureDetector(
                      onTap: onAddToCart,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: DimensionConstants.paddingS,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstants.primary,
                          borderRadius: BorderRadius.circular(DimensionConstants.radiusS),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: DimensionConstants.iconS,
                            ),
                            SizedBox(width: DimensionConstants.marginXS),
                            Text(
                              'Add to Cart',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: DimensionConstants.textS,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}