import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../widgets/animated_fade_in.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_shimmer.dart';
import '../../widgets/product_card.dart';
import 'product_detail_controller.dart';
import 'widgets/color_selector.dart';
import 'widgets/size_selector.dart';
import 'widgets/quantity_selector.dart';
import 'widgets/product_image_viewer.dart';

class ProductDetailScreen extends GetView<ProductDetailController> {
  const ProductDetailScreen({Key? key}) : super(key: key);

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
    final backgroundColor =
        isDarkMode
            ? ColorConstants.backgroundDark
            : ColorConstants.backgroundLight;
    final cardColor =
        isDarkMode ? ColorConstants.cardDark : ColorConstants.cardLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingView();
        }

        if (controller.hasError.value) {
          return _buildErrorView();
        }

        final product = controller.product.value;
        if (product == null) {
          return _buildErrorView(message: 'Product not found');
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.width,
              pinned: true,
              backgroundColor: backgroundColor,
              elevation: 0,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
              actions: [
                // Wishlist button
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      controller.isInWishlist.value
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          controller.isInWishlist.value
                              ? ColorConstants.accent
                              : Colors.white,
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      controller.toggleWishlist();
                    },
                  ),
                ),
                // Share button
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      // Share functionality
                    },
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: ProductImageViewer(
                  images: product.images,
                  currentIndex: controller.currentImageIndex.value,
                  pageController: controller.pageController,
                  onIndexChanged:
                      (index) => controller.currentImageIndex.value = index,
                ),
              ),
            ),

            // Product details
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(DimensionConstants.radiusXL),
                    topRight: Radius.circular(DimensionConstants.radiusXL),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(DimensionConstants.paddingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name and rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product name
                          Expanded(
                            child: AnimatedFadeIn(
                              child: Text(
                                product.name,
                                style: TextStyle(
                                  fontSize: DimensionConstants.textXXL,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: DimensionConstants.marginM),

                          // Product rating
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: DimensionConstants.paddingS,
                              vertical: DimensionConstants.paddingXS,
                            ),
                            decoration: BoxDecoration(
                              color: ColorConstants.accent,
                              borderRadius: BorderRadius.circular(
                                DimensionConstants.radiusS,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: DimensionConstants.iconXS,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  product.rating.toString(),
                                  style: const TextStyle(
                                    fontSize: DimensionConstants.textS,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Brand if available
                      if (product.brand != null) ...[
                        const SizedBox(height: DimensionConstants.marginS),
                        Text(
                          product.brand!,
                          style: TextStyle(
                            fontSize: DimensionConstants.textM,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],

                      // Pricing
                      const SizedBox(height: DimensionConstants.marginL),
                      Row(
                        children: [
                          // Current price
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: DimensionConstants.heading3,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),

                          // Original price if on sale
                          if (product.isOnSale) ...[
                            const SizedBox(width: DimensionConstants.marginM),
                            Text(
                              '\$${product.compareAtPrice!.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: DimensionConstants.textL,
                                decoration: TextDecoration.lineThrough,
                                color: secondaryTextColor,
                              ),
                            ),
                            const SizedBox(width: DimensionConstants.marginS),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: DimensionConstants.paddingS,
                                vertical: DimensionConstants.paddingXS,
                              ),
                              decoration: BoxDecoration(
                                color: ColorConstants.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                  DimensionConstants.radiusXS,
                                ),
                              ),
                              child: Text(
                                '-${product.discountPercentage.toInt()}%',
                                style: const TextStyle(
                                  color: ColorConstants.success,
                                  fontWeight: FontWeight.bold,
                                  fontSize: DimensionConstants.textS,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      // In stock status
                      const SizedBox(height: DimensionConstants.marginS),
                      Row(
                        children: [
                          Icon(
                            product.isInStock
                                ? Icons.check_circle_outline
                                : Icons.cancel_outlined,
                            size: DimensionConstants.iconS,
                            color:
                                product.isInStock
                                    ? ColorConstants.success
                                    : ColorConstants.error,
                          ),
                          const SizedBox(width: DimensionConstants.marginXS),
                          Text(
                            product.isInStock
                                ? 'In Stock (${product.quantity} available)'
                                : 'Out of Stock',
                            style: TextStyle(
                              fontSize: DimensionConstants.textS,
                              color:
                                  product.isInStock
                                      ? ColorConstants.success
                                      : ColorConstants.error,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: DimensionConstants.marginL),

                      // Color selector
                      if (product.colors?.isNotEmpty == true) ...[
                        Text(
                          'Color',
                          style: TextStyle(
                            fontSize: DimensionConstants.textL,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: DimensionConstants.marginM),
                        Obx(
                          () => ColorSelector(
                            colors: product.colors!,
                            selectedColor: controller.selectedColor.value,
                            onColorSelected: controller.setColor,
                          ),
                        ),
                        const SizedBox(height: DimensionConstants.marginL),
                      ],

                      // Size selector
                      if (product.sizes?.isNotEmpty == true) ...[
                        Text(
                          'Size',
                          style: TextStyle(
                            fontSize: DimensionConstants.textL,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: DimensionConstants.marginM),
                        Obx(
                          () => SizeSelector(
                            sizes: product.sizes!,
                            selectedSize: controller.selectedSize.value,
                            onSizeSelected: controller.setSize,
                          ),
                        ),
                        const SizedBox(height: DimensionConstants.marginL),
                      ],

                      // Quantity selector
                      Text(
                        'Quantity',
                        style: TextStyle(
                          fontSize: DimensionConstants.textL,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: DimensionConstants.marginM),
                      Obx(
                        () => QuantitySelector(
                          quantity: controller.quantity.value,
                          onIncrement: controller.incrementQuantity,
                          onDecrement: controller.decrementQuantity,
                        ),
                      ),

                      const SizedBox(height: DimensionConstants.marginXL),

                      // Description
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: DimensionConstants.textL,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: DimensionConstants.marginM),
                      Text(
                        product.description,
                        style: TextStyle(
                          fontSize: DimensionConstants.textM,
                          color: secondaryTextColor,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: DimensionConstants.marginXL),

                      // Seller info
                      if (product.sellerName != null) ...[
                        Text(
                          'Sold by',
                          style: TextStyle(
                            fontSize: DimensionConstants.textL,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: DimensionConstants.marginM),
                        Container(
                          padding: const EdgeInsets.all(
                            DimensionConstants.paddingM,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isDarkMode
                                    ? Colors.black12
                                    : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(
                              DimensionConstants.radiusM,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: ColorConstants.primary
                                    .withOpacity(0.1),
                                child: Text(
                                  product.sellerName![0],
                                  style: const TextStyle(
                                    color: ColorConstants.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: DimensionConstants.marginM),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.sellerName!,
                                      style: TextStyle(
                                        fontSize: DimensionConstants.textM,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'View seller profile',
                                      style: TextStyle(
                                        fontSize: DimensionConstants.textS,
                                        color: ColorConstants.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: DimensionConstants.iconXS,
                                color: ColorConstants.primary,
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: DimensionConstants.marginXL),

                      // Reviews summary
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reviews (${product.reviewCount})',
                            style: TextStyle(
                              fontSize: DimensionConstants.textL,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to reviews
                            },
                            child: const Text(
                              'See All',
                              style: TextStyle(
                                fontSize: DimensionConstants.textM,
                                color: ColorConstants.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: DimensionConstants.marginM),

                      // Sample review
                      Container(
                        padding: const EdgeInsets.all(
                          DimensionConstants.paddingM,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isDarkMode
                                  ? Colors.black12
                                  : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(
                            DimensionConstants.radiusM,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 16,
                                  backgroundColor: ColorConstants.primary,
                                  child: Icon(
                                    Icons.person,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: DimensionConstants.marginM,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'John Doe',
                                        style: TextStyle(
                                          fontSize: DimensionConstants.textM,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Posted 2 days ago',
                                        style: TextStyle(
                                          fontSize: DimensionConstants.textXS,
                                          color: secondaryTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < product.rating.floor()
                                          ? Icons.star
                                          : index < product.rating
                                          ? Icons.star_half
                                          : Icons.star_outline,
                                      color: ColorConstants.accent,
                                      size: DimensionConstants.iconXS,
                                    );
                                  }),
                                ),
                              ],
                            ),
                            const SizedBox(height: DimensionConstants.marginM),
                            Text(
                              'This product exceeded my expectations! The quality is excellent and it arrived faster than expected.',
                              style: TextStyle(
                                fontSize: DimensionConstants.textM,
                                color: textColor,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: DimensionConstants.marginXL),

                      // Related products
                      Obx(() {
                        if (controller.relatedProducts.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'You may also like',
                              style: TextStyle(
                                fontSize: DimensionConstants.textL,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: DimensionConstants.marginL),
                            SizedBox(
                              height: 380,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: controller.relatedProducts.length,
                                itemBuilder: (context, index) {
                                  final relatedProduct =
                                      controller.relatedProducts[index];
                                  return Container(
                                    width: 220,
                                    margin: EdgeInsets.only(
                                      right:
                                          index ==
                                                  controller
                                                          .relatedProducts
                                                          .length -
                                                      1
                                              ? 0
                                              : DimensionConstants.marginM,
                                    ),
                                    child: ProductCard(
                                      product: relatedProduct,
                                      onAddToCart: () {
                                        HapticFeedback.mediumImpact();
                                        // Add related product to cart
                                      },
                                      onAddToWishlist: () {
                                        HapticFeedback.lightImpact();
                                        // Add related product to wishlist
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: DimensionConstants.marginXXL),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),

      // Bottom bar with Add to Cart and Buy Now buttons
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value ||
            controller.hasError.value ||
            controller.product.value == null) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: EdgeInsets.only(
            left: DimensionConstants.paddingL,
            right: DimensionConstants.paddingL,
            top: DimensionConstants.paddingM,
            bottom:
                DimensionConstants.paddingM +
                MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Add to Cart button
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    controller.addToCart();
                  },
                  backgroundColor: isDarkMode ? Colors.black26 : Colors.white,
                  textColor: ColorConstants.primary,
                  borderColor: ColorConstants.primary,
                  text: 'Add to Cart',
                  icon: Icons.shopping_cart_outlined,
                ),
              ),
              const SizedBox(width: DimensionConstants.marginM),

              // Buy Now button
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    controller.buyNow();
                  },
                  backgroundColor: ColorConstants.primary,
                  textColor: Colors.white,
                  text: 'Buy Now',
                  icon: Icons.flash_on,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLoadingView() {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        const SliverAppBar(expandedHeight: 300, pinned: true),
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(DimensionConstants.radiusXL),
                topRight: Radius.circular(DimensionConstants.radiusXL),
              ),
            ),
            padding: const EdgeInsets.all(DimensionConstants.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const CustomShimmer(
                  width: double.infinity,
                  height: 30,
                  borderRadius: DimensionConstants.radiusS,
                ),
                const SizedBox(height: DimensionConstants.marginM),

                // Price
                const CustomShimmer(
                  width: 150,
                  height: 25,
                  borderRadius: DimensionConstants.radiusS,
                ),
                const SizedBox(height: DimensionConstants.marginL),

                // Color options
                const CustomShimmer(
                  width: 120,
                  height: 20,
                  borderRadius: DimensionConstants.radiusS,
                ),
                const SizedBox(height: DimensionConstants.marginM),
                Row(
                  children: List.generate(
                    5,
                    (index) => Container(
                      margin: const EdgeInsets.only(
                        right: DimensionConstants.marginS,
                      ),
                      child: const CustomShimmer(
                        width: 40,
                        height: 40,
                        borderRadius: DimensionConstants.radiusCircular,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: DimensionConstants.marginL),

                // Size options
                const CustomShimmer(
                  width: 120,
                  height: 20,
                  borderRadius: DimensionConstants.radiusS,
                ),
                const SizedBox(height: DimensionConstants.marginM),
                Row(
                  children: List.generate(
                    4,
                    (index) => Container(
                      margin: const EdgeInsets.only(
                        right: DimensionConstants.marginS,
                      ),
                      child: const CustomShimmer(
                        width: 50,
                        height: 40,
                        borderRadius: DimensionConstants.radiusS,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: DimensionConstants.marginL),

                // Quantity
                const CustomShimmer(
                  width: 120,
                  height: 20,
                  borderRadius: DimensionConstants.radiusS,
                ),
                const SizedBox(height: DimensionConstants.marginM),
                const CustomShimmer(
                  width: 180,
                  height: 40,
                  borderRadius: DimensionConstants.radiusS,
                ),
                const SizedBox(height: DimensionConstants.marginXL),

                // Description
                const CustomShimmer(
                  width: 120,
                  height: 20,
                  borderRadius: DimensionConstants.radiusS,
                ),
                const SizedBox(height: DimensionConstants.marginM),
                const CustomShimmer(
                  width: double.infinity,
                  height: 120,
                  borderRadius: DimensionConstants.radiusS,
                ),
                const SizedBox(height: DimensionConstants.marginXXL),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView({String? message}) {
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
            message ?? controller.errorMessage.value,
            style: const TextStyle(
              fontSize: DimensionConstants.textL,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DimensionConstants.marginL),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
