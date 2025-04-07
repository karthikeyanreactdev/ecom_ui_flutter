import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../widgets/animated_fade_in.dart';
import '../../widgets/custom_button.dart';
import '../../data/models/product_model.dart';
import 'wishlist_controller.dart';

class WishlistScreen extends GetView<WishlistController> {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode
            ? ColorConstants.backgroundDark
            : ColorConstants.backgroundLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildLoadingView();
          }

          if (controller.hasError.value) {
            return _buildErrorView();
          }

          if (controller.wishlistItems.isEmpty) {
            return _buildEmptyView();
          }

          return _buildWishlistView(context);
        }),
      ),
    );
  }

  Widget _buildWishlistView(BuildContext context) {
    final isDarkMode = context.theme.brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: controller.refreshWishlist,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          SliverAppBar(
            title: Text('My Wishlist (${controller.wishlistItems.length})'),
            floating: true,
            actions: [
              // Clear all button
              IconButton(
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Clear all',
                onPressed: controller.clearWishlist,
              ),
            ],
          ),

          // Wishlist items
          SliverPadding(
            padding: const EdgeInsets.all(DimensionConstants.paddingL),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: DimensionConstants.marginM,
                mainAxisSpacing: DimensionConstants.marginM,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = controller.wishlistItems[index];
                return AnimatedFadeIn(
                  delay: Duration(milliseconds: index * 50),
                  child: WishlistItemCard(
                    product: product,
                    onTap: () => controller.navigateToProductDetail(product),
                    onRemove: () {
                      HapticFeedback.lightImpact();
                      controller.removeFromWishlist(product.id);
                    },
                    onAddToCart: () {
                      HapticFeedback.mediumImpact();
                      controller.addToCart(product);
                    },
                  ),
                );
              }, childCount: controller.wishlistItems.length),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: DimensionConstants.marginXL),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
            color: ColorConstants.error,
          ),
          const SizedBox(height: DimensionConstants.marginL),
          Text(
            controller.errorMessage.value,
            style: const TextStyle(
              fontSize: DimensionConstants.textL,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DimensionConstants.marginL),
          ElevatedButton(
            onPressed: controller.refreshWishlist,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: DimensionConstants.marginL),
          const Text(
            'Your Wishlist is Empty',
            style: TextStyle(
              fontSize: DimensionConstants.textXL,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: DimensionConstants.marginM),
          const Text(
            'Items added to your wishlist will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: DimensionConstants.textM,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: DimensionConstants.marginXL),
          CustomButton(
            text: 'Explore Products',
            onPressed: () {
              // Navigate to home
              Get.offAndToNamed('/dashboard');
            },
          ),
        ],
      ),
    );
  }
}

class WishlistItemCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;

  const WishlistItemCard({
    Key? key,
    required this.product,
    required this.onTap,
    required this.onRemove,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : ColorConstants.textPrimary;
    final secondaryTextColor =
        isDarkMode ? Colors.white70 : ColorConstants.textSecondary;
    final cardColor =
        isDarkMode ? ColorConstants.surfaceDark : ColorConstants.surfaceLight;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image with remove button
          Stack(
            children: [
              // Product image
              GestureDetector(
                onTap: onTap,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(DimensionConstants.radiusM),
                    topRight: Radius.circular(DimensionConstants.radiusM),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child:
                        product.images.isNotEmpty
                            ? Image.network(
                              product.images[0],
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
              ),

              // Remove button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),

              // Sale tag
              if (product.isOnSale)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DimensionConstants.paddingS,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ColorConstants.accent,
                      borderRadius: BorderRadius.circular(
                        DimensionConstants.radiusXS,
                      ),
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
            ],
          ),

          // Product details
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(DimensionConstants.paddingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand if available
                    if (product.brand != null)
                      Text(
                        product.brand!,
                        style: TextStyle(
                          fontSize: DimensionConstants.textXS,
                          color: secondaryTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                    // Product name
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: DimensionConstants.textM,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: DimensionConstants.marginXS),

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
                          const SizedBox(width: DimensionConstants.marginXS),
                          Text(
                            '\$${product.compareAtPrice!.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: DimensionConstants.textS,
                              decoration: TextDecoration.lineThrough,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const Spacer(),

                    // Add to cart button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: product.isInStock ? onAddToCart : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              DimensionConstants.radiusS,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: DimensionConstants.paddingS,
                          ),
                          disabledBackgroundColor:
                              isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade300,
                        ),
                        child: Text(
                          product.isInStock ? 'Add to Cart' : 'Out of Stock',
                          style: const TextStyle(
                            fontSize: DimensionConstants.textS,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
