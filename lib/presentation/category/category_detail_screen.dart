import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../routes/app_routes.dart';
import '../../widgets/animated_fade_in.dart';
import '../../widgets/custom_shimmer.dart';
import '../../widgets/product_card.dart';
import 'category_detail_controller.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'widgets/sort_bottom_sheet.dart';

class CategoryDetailScreen extends GetView<CategoryDetailController> {
  const CategoryDetailScreen({Key? key}) : super(key: key);

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

          if (controller.category.value == null) {
            return _buildErrorView(message: 'Category not found');
          }

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: Text(controller.category.value!.name),
                  floating: true,
                  backgroundColor: backgroundColor,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => Get.toNamed(AppRoutes.search),
                    ),
                  ],
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _FilterHeaderDelegate(
                    child: _buildFilterHeader(context),
                    controller: controller,
                  ),
                ),
              ];
            },
            body: RefreshIndicator(
              onRefresh: controller.refreshProducts,
              child: Obx(() {
                if (controller.products.isEmpty) {
                  return _buildEmptyProductsView();
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: _handleScrollNotification,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(DimensionConstants.paddingL),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: DimensionConstants.marginM,
                          mainAxisSpacing: DimensionConstants.marginM,
                        ),
                    itemCount:
                        controller.isLoadingMore.value
                            ? controller.products.length +
                                2 // Add loading indicators
                            : controller.products.length,
                    itemBuilder: (context, index) {
                      // Show loading indicators at the end
                      if (index >= controller.products.length) {
                        return const ProductCardShimmer();
                      }

                      final product = controller.products[index];
                      return AnimatedFadeIn(
                        delay: Duration(milliseconds: index * 50),
                        child: ProductCard(
                          product: product,
                          onAddToCart: () {
                            HapticFeedback.mediumImpact();
                            // Add to cart functionality
                            Get.snackbar(
                              'Added to Cart',
                              '${product.name} has been added to your cart',
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(
                                DimensionConstants.marginL,
                              ),
                              backgroundColor: ColorConstants.primary,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 2),
                            );
                          },
                          onAddToWishlist: () {
                            HapticFeedback.lightImpact();
                            // Wishlist functionality
                          },
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFilterHeader(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode
            ? ColorConstants.backgroundDark
            : ColorConstants.backgroundLight;
    final dividerColor =
        isDarkMode ? ColorConstants.dividerDark : ColorConstants.dividerLight;
    final textColor =
        isDarkMode
            ? ColorConstants.textPrimaryDark
            : ColorConstants.textPrimaryLight;

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(
        horizontal: DimensionConstants.paddingL,
        vertical: DimensionConstants.paddingM,
      ),
      child: Column(
        children: [
          // Category description
          if (controller.category.value?.description != null) ...[
            Text(
              controller.category.value!.description!,
              style: TextStyle(
                fontSize: DimensionConstants.textM,
                color:
                    isDarkMode
                        ? ColorConstants.textSecondaryDark
                        : ColorConstants.textSecondaryLight,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: DimensionConstants.marginM),
          ],

          // Filter and Sort row
          Row(
            children: [
              // Product count
              Expanded(
                child: Text(
                  '${controller.products.length} products',
                  style: TextStyle(
                    fontSize: DimensionConstants.textS,
                    color: textColor,
                  ),
                ),
              ),

              // Sort button
              InkWell(
                onTap: () => _showSortBottomSheet(context),
                borderRadius: BorderRadius.circular(DimensionConstants.radiusS),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DimensionConstants.paddingM,
                    vertical: DimensionConstants.paddingS,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.sort, size: DimensionConstants.iconS),
                      const SizedBox(width: DimensionConstants.marginXS),
                      Text(
                        'Sort',
                        style: TextStyle(
                          fontSize: DimensionConstants.textS,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Divider
              Container(
                height: 20,
                width: 1,
                color: dividerColor,
                margin: const EdgeInsets.symmetric(
                  horizontal: DimensionConstants.marginS,
                ),
              ),

              // Filter button
              InkWell(
                onTap: () => _showFilterBottomSheet(context),
                borderRadius: BorderRadius.circular(DimensionConstants.radiusS),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DimensionConstants.paddingM,
                    vertical: DimensionConstants.paddingS,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.filter_list,
                        size: DimensionConstants.iconS,
                      ),
                      const SizedBox(width: DimensionConstants.marginXS),
                      Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: DimensionConstants.textS,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      if (controller.activeFilters.isNotEmpty) ...[
                        const SizedBox(width: DimensionConstants.marginXS),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: ColorConstants.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            controller.activeFilters.length.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Active filters indicators
          if (controller.activeFilters.isNotEmpty) ...[
            const SizedBox(height: DimensionConstants.marginM),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...controller.activeFilters.entries.map((filter) {
                    return Container(
                      margin: const EdgeInsets.only(
                        right: DimensionConstants.marginS,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: DimensionConstants.paddingS,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          DimensionConstants.radiusXS,
                        ),
                        border: Border.all(
                          color: ColorConstants.primary,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${filter.key}: ${filter.value}',
                            style: const TextStyle(
                              fontSize: DimensionConstants.textXS,
                              color: ColorConstants.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap:
                                () => controller.toggleFilter(
                                  filter.key,
                                  filter.value,
                                ),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: ColorConstants.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  // Clear all button
                  GestureDetector(
                    onTap: controller.resetFilters,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DimensionConstants.paddingS,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          DimensionConstants.radiusXS,
                        ),
                        border: Border.all(
                          color:
                              isDarkMode
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade400,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Clear All',
                        style: TextStyle(
                          fontSize: DimensionConstants.textXS,
                          color:
                              isDarkMode
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    Get.bottomSheet(
      SortBottomSheet(
        currentSortOption: controller.sortOption.value,
        onSortOptionSelected: controller.setSortOption,
      ),
      isScrollControlled: true,
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      FilterBottomSheet(
        activeFilters: controller.activeFilters,
        onFilterToggled: controller.toggleFilter,
        onResetFilters: controller.resetFilters,
        category: controller.category.value!,
      ),
      isScrollControlled: true,
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (notification.metrics.pixels >=
              notification.metrics.maxScrollExtent - 200 &&
          !controller.isLoadingMore.value &&
          controller.page.value < controller.totalPages.value) {
        controller.loadMoreProducts();
      }
    }
    return false;
  }

  Widget _buildLoadingView() {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(title: Text('Loading...'), floating: true),
        SliverPadding(
          padding: const EdgeInsets.all(DimensionConstants.paddingL),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: DimensionConstants.marginM,
              mainAxisSpacing: DimensionConstants.marginM,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => const ProductCardShimmer(),
              childCount: 6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView({String? message}) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(title: Text('Error'), floating: true),
        SliverFillRemaining(
          child: Center(
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
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyProductsView() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildFilterHeader(Get.context!)),
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 80,
                  color: Colors.grey.withOpacity(0.5),
                ),
                const SizedBox(height: DimensionConstants.marginL),
                const Text(
                  'No Products Found',
                  style: TextStyle(
                    fontSize: DimensionConstants.textXL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: DimensionConstants.marginM),
                const Text(
                  'We couldn\'t find any products in this category',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: DimensionConstants.textM,
                    color: Colors.grey,
                  ),
                ),
                if (controller.activeFilters.isNotEmpty) ...[
                  const SizedBox(height: DimensionConstants.marginM),
                  const Text(
                    'Try removing some filters',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: DimensionConstants.textM,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: DimensionConstants.marginXL),
                  ElevatedButton(
                    onPressed: controller.resetFilters,
                    child: const Text('Clear Filters'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final CategoryDetailController controller;

  _FilterHeaderDelegate({required this.child, required this.controller});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => controller.activeFilters.isEmpty ? 100 : 140;

  @override
  double get minExtent => controller.activeFilters.isEmpty ? 100 : 140;

  @override
  bool shouldRebuild(covariant _FilterHeaderDelegate oldDelegate) {
    return true;
  }
}
