import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../routes/app_routes.dart';
import '../../widgets/animated_fade_in.dart';
import '../../widgets/custom_shimmer.dart';
import '../../widgets/product_card.dart';
import 'search_controller.dart';

class SearchScreen extends GetView<SearchController> {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode
            ? ColorConstants.backgroundDark
            : ColorConstants.backgroundLight;
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

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DimensionConstants.paddingL,
                vertical: DimensionConstants.paddingM,
              ),
              color: isDarkMode ? ColorConstants.cardDark : Colors.white,
              child: Row(
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Get.back(),
                  ),

                  // Search input
                  Expanded(
                    child: TextField(
                      controller: controller.textController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        hintStyle: TextStyle(color: secondaryTextColor),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: Obx(
                          () =>
                              controller.textController.text.isNotEmpty
                                  ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: controller.clearSearch,
                                  )
                                  : const SizedBox.shrink(),
                        ),
                        filled: true,
                        fillColor: inputBackground,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: DimensionConstants.paddingM,
                          vertical: 0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            DimensionConstants.radiusM,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            DimensionConstants.radiusM,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            DimensionConstants.radiusM,
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: DimensionConstants.textM,
                        color: textColor,
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          controller.search(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Results or Suggestions
            Expanded(
              child: Obx(() {
                // Show search results if available
                if (controller.searchResults.isNotEmpty) {
                  return _buildSearchResults(context);
                }

                // Show loading indicator
                if (controller.isLoading.value) {
                  return _buildLoadingView();
                }

                // Show empty state if searched but no results
                if (controller.textController.text.isNotEmpty &&
                    !controller.isLoading.value &&
                    controller.searchResults.isEmpty) {
                  return _buildEmptyResults();
                }

                // Show suggestions
                return _buildSuggestions(context);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode
            ? ColorConstants.textPrimaryDark
            : ColorConstants.textPrimaryLight;
    final secondaryTextColor =
        isDarkMode
            ? ColorConstants.textSecondaryDark
            : ColorConstants.textSecondaryLight;

    return ListView(
      padding: const EdgeInsets.all(DimensionConstants.paddingL),
      children: [
        // Recent searches
        Obx(() {
          if (controller.textController.text.isNotEmpty &&
              controller.recentSearches.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: DimensionConstants.textL,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: DimensionConstants.marginM),
                ...controller.recentSearches
                    .map(
                      (search) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.history),
                        title: Text(search),
                        onTap: () {
                          controller.textController.text = search;
                          controller.search(search);
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed:
                              () => controller.removeFromSearchHistory(search),
                        ),
                      ),
                    )
                    .toList(),
                const SizedBox(height: DimensionConstants.marginM),
              ],
            );
          }
          return const SizedBox.shrink();
        }),

        // Search history
        Obx(() {
          if (controller.textController.text.isEmpty &&
              controller.searchHistory.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Searches',
                      style: TextStyle(
                        fontSize: DimensionConstants.textL,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    TextButton(
                      onPressed: controller.clearSearchHistory,
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
                const SizedBox(height: DimensionConstants.marginS),
                ...controller.searchHistory
                    .take(5)
                    .map(
                      (search) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.history),
                        title: Text(search),
                        onTap: () {
                          controller.textController.text = search;
                          controller.search(search);
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed:
                              () => controller.removeFromSearchHistory(search),
                        ),
                      ),
                    )
                    .toList(),
                const SizedBox(height: DimensionConstants.marginL),
              ],
            );
          }
          return const SizedBox.shrink();
        }),

        // Category suggestions
        Obx(() {
          if (controller.textController.text.isNotEmpty &&
              controller.suggestedCategories.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: DimensionConstants.textL,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: DimensionConstants.marginM),
                Wrap(
                  spacing: DimensionConstants.marginS,
                  runSpacing: DimensionConstants.marginS,
                  children:
                      controller.suggestedCategories
                          .map(
                            (category) => GestureDetector(
                              onTap: () {
                                // Navigate to category
                                Get.back();
                              },
                              child: Chip(
                                label: Text(category),
                                backgroundColor:
                                    isDarkMode
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade200,
                                labelStyle: TextStyle(color: textColor),
                              ),
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: DimensionConstants.marginL),
              ],
            );
          }
          return const SizedBox.shrink();
        }),

        // Suggested products
        Obx(() {
          if (controller.textController.text.isEmpty &&
              controller.suggestedProducts.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Popular Products',
                  style: TextStyle(
                    fontSize: DimensionConstants.textL,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: DimensionConstants.marginM),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: DimensionConstants.marginM,
                    mainAxisSpacing: DimensionConstants.marginM,
                  ),
                  itemCount: controller.suggestedProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.suggestedProducts[index];
                    return ProductCard(
                      product: product,
                      onAddToCart: () {
                        HapticFeedback.mediumImpact();
                        // Add to cart
                      },
                      onAddToWishlist: () {
                        HapticFeedback.lightImpact();
                        // Add to wishlist
                      },
                    );
                  },
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          if (notification.metrics.pixels >=
              notification.metrics.maxScrollExtent - 200) {
            controller.loadMoreResults();
          }
        }
        return false;
      },
      child: CustomScrollView(
        slivers: [
          // Results count and filters
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(DimensionConstants.paddingL),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${controller.searchResults.length} results',
                    style: const TextStyle(
                      fontSize: DimensionConstants.textM,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      // Sort button
                      InkWell(
                        onTap: () {
                          // Show sort options
                        },
                        borderRadius: BorderRadius.circular(
                          DimensionConstants.radiusS,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(DimensionConstants.paddingS),
                          child: Row(
                            children: [
                              Icon(Icons.sort, size: DimensionConstants.iconS),
                              SizedBox(width: 4),
                              Text('Sort'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: DimensionConstants.marginS),
                      // Filter button
                      InkWell(
                        onTap: () {
                          // Show filter options
                        },
                        borderRadius: BorderRadius.circular(
                          DimensionConstants.radiusS,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(DimensionConstants.paddingS),
                          child: Row(
                            children: [
                              Icon(
                                Icons.filter_list,
                                size: DimensionConstants.iconS,
                              ),
                              SizedBox(width: 4),
                              Text('Filter'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Results grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: DimensionConstants.paddingL,
              vertical: DimensionConstants.paddingM,
            ),
            sliver: Obx(
              () => SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: DimensionConstants.marginM,
                  mainAxisSpacing: DimensionConstants.marginM,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Show loading indicator at the end when loading more
                    if (index >= controller.searchResults.length) {
                      return const ProductCardShimmer();
                    }

                    final product = controller.searchResults[index];
                    return AnimatedFadeIn(
                      delay: Duration(milliseconds: index * 50),
                      child: ProductCard(
                        product: product,
                        onAddToCart: () {
                          HapticFeedback.mediumImpact();
                          // Add to cart
                        },
                        onAddToWishlist: () {
                          HapticFeedback.lightImpact();
                          // Add to wishlist
                        },
                      ),
                    );
                  },
                  childCount:
                      controller.isLoadingMore.value
                          ? controller.searchResults.length + 2
                          : controller.searchResults.length,
                ),
              ),
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
    return Padding(
      padding: const EdgeInsets.all(DimensionConstants.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomShimmer(
            width: 150,
            height: 24,
            borderRadius: DimensionConstants.radiusXS,
          ),
          const SizedBox(height: DimensionConstants.marginL),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: DimensionConstants.marginM,
                mainAxisSpacing: DimensionConstants.marginM,
              ),
              itemCount: 6,
              itemBuilder: (context, index) => const ProductCardShimmer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: DimensionConstants.marginL),
          const Text(
            'No Results Found',
            style: TextStyle(
              fontSize: DimensionConstants.textXL,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: DimensionConstants.marginM),
          Text(
            'We couldn\'t find any products matching\n"${controller.textController.text}"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: DimensionConstants.textM,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: DimensionConstants.marginXL),
          ElevatedButton(
            onPressed: controller.clearSearch,
            child: const Text('Clear Search'),
          ),
        ],
      ),
    );
  }
}
