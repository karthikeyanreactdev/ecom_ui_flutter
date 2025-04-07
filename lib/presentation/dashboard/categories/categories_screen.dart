import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';
import '../../../data/models/category_model.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/animated_fade_in.dart';
import '../../../widgets/custom_shimmer.dart';
import 'categories_controller.dart';
import 'widgets/category_card.dart';

class CategoriesScreen extends GetView<CategoriesController> {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode
            ? ColorConstants.textPrimaryDark
            : ColorConstants.textPrimaryLight;
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

          if (controller.categories.isEmpty) {
            return _buildEmptyView();
          }

          return RefreshIndicator(
            onRefresh: controller.refreshCategories,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // App Bar
                SliverAppBar(
                  title: const Text('Categories'),
                  floating: true,
                  backgroundColor: backgroundColor,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => Get.toNamed(AppRoutes.search),
                    ),
                  ],
                ),

                // Categories Grid
                SliverPadding(
                  padding: const EdgeInsets.all(DimensionConstants.paddingL),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final category = controller.categories[index];
                      return AnimatedFadeIn(
                        delay: Duration(milliseconds: index * 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index > 0)
                              const SizedBox(
                                height: DimensionConstants.marginXL,
                              ),

                            // Category tile
                            CategoryCard(
                              category: category,
                              onTap: () => _navigateToCategoryDetail(category),
                            ),

                            // Subcategories if available
                            if (category.subcategories?.isNotEmpty == true) ...[
                              const SizedBox(
                                height: DimensionConstants.marginM,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: DimensionConstants.paddingL,
                                ),
                                child: Text(
                                  'Subcategories',
                                  style: TextStyle(
                                    fontSize: DimensionConstants.textM,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: DimensionConstants.marginS,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: category.subcategories!.length,
                                itemBuilder: (context, subIndex) {
                                  final subcategory =
                                      category.subcategories![subIndex];
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      left: DimensionConstants.paddingL,
                                      top: DimensionConstants.paddingS,
                                    ),
                                    child: CategoryCard(
                                      category: subcategory,
                                      isSubcategory: true,
                                      onTap:
                                          () => _navigateToCategoryDetail(
                                            subcategory,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      );
                    }, childCount: controller.categories.length),
                  ),
                ),

                // Bottom padding
                const SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: DimensionConstants.paddingXXL,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _navigateToCategoryDetail(CategoryModel category) {
    Get.toNamed(AppRoutes.categoryDetail, arguments: category);
  }

  Widget _buildLoadingView() {
    return ListView.builder(
      padding: const EdgeInsets.all(DimensionConstants.paddingL),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: DimensionConstants.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category shimmer
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    DimensionConstants.radiusM,
                  ),
                ),
                child: const CustomShimmer(
                  width: double.infinity,
                  height: 120,
                  borderRadius: DimensionConstants.radiusM,
                ),
              ),

              // Subcategories shimmer
              if (index % 2 == 0) ...[
                const SizedBox(height: DimensionConstants.marginM),
                const Padding(
                  padding: EdgeInsets.only(left: DimensionConstants.paddingL),
                  child: CustomShimmer(
                    width: 100,
                    height: 18,
                    borderRadius: DimensionConstants.radiusXS,
                  ),
                ),
                const SizedBox(height: DimensionConstants.marginM),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, subIndex) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: DimensionConstants.paddingL,
                        bottom: DimensionConstants.paddingS,
                      ),
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            DimensionConstants.radiusS,
                          ),
                        ),
                        child: const CustomShimmer(
                          width: double.infinity,
                          height: 80,
                          borderRadius: DimensionConstants.radiusS,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
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
            onPressed: controller.refreshCategories,
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
            Icons.category_outlined,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: DimensionConstants.marginL),
          const Text(
            'No Categories Found',
            style: TextStyle(
              fontSize: DimensionConstants.textXL,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: DimensionConstants.marginM),
          const Text(
            'We couldn\'t find any product categories',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: DimensionConstants.textM,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: DimensionConstants.marginXL),
          ElevatedButton(
            onPressed: controller.refreshCategories,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}
