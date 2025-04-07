import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/animated_fade_in.dart';
import '../../../widgets/banner_slider.dart';
import '../../../widgets/category_chip.dart';
import '../../../widgets/custom_shimmer.dart';
import '../../../widgets/product_card.dart';
import '../../../widgets/section_header.dart';
import 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshHomeData,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                pinned: false,
                snap: false,
                title: Text(
                  TextConstants.appName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  // Search Button
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => Get.toNamed(AppRoutes.search),
                  ),
                  // Notifications Button
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () => Get.toNamed(AppRoutes.notifications),
                  ),
                ],
              ),
              
              // Content
              SliverPadding(
                padding: const EdgeInsets.only(top: DimensionConstants.paddingM),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Banner Slider
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: DimensionConstants.paddingL,
                          ),
                          child: BannerShimmer(),
                        );
                      }
                      return AnimatedFadeIn(
                        child: BannerSlider(
                          bannerUrls: controller.banners,
                          onBannerTap: (index) {
                            // Handle banner tap
                            // Could navigate to specific promotion page based on banner index
                          },
                        ),
                      );
                    }),
                    
                    const SizedBox(height: DimensionConstants.marginXL),
                    
                    // Categories Section
                    SectionHeader(
                      title: 'Categories',
                      actionText: 'See All',
                      onActionTap: () => Get.toNamed(AppRoutes.categories),
                    ),
                    
                    Obx(() {
                      if (controller.isLoading.value) {
                        return SizedBox(
                          height: DimensionConstants.categoryImageSize * 1.8,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: DimensionConstants.paddingL,
                            ),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return const Padding(
                                padding: EdgeInsets.only(right: DimensionConstants.paddingM),
                                child: CategoryShimmer(),
                              );
                            },
                          ),
                        );
                      }
                      
                      return AnimatedFadeIn(
                        child: SizedBox(
                          height: DimensionConstants.categoryImageSize * 1.8,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: DimensionConstants.paddingL,
                            ),
                            itemCount: controller.popularCategories.length,
                            itemBuilder: (context, index) {
                              final category = controller.popularCategories[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: DimensionConstants.paddingM),
                                child: CategoryChip(category: category),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                    
                    const SizedBox(height: DimensionConstants.marginXL),
                    
                    // Featured Products
                    SectionHeader(
                      title: 'Featured Products',
                      actionText: 'See All',
                      onActionTap: () {
                        // Navigate to featured products page
                      },
                    ),
                    
                    Obx(() {
                      if (controller.isLoading.value) {
                        return SizedBox(
                          height: 380,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: DimensionConstants.paddingL,
                            ),
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 220,
                                margin: const EdgeInsets.only(right: DimensionConstants.marginM),
                                child: const ProductCardShimmer(),
                              );
                            },
                          ),
                        );
                      }
                      
                      return AnimatedFadeIn(
                        child: SizedBox(
                          height: 380,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: DimensionConstants.paddingL,
                            ),
                            itemCount: controller.featuredProducts.length,
                            itemBuilder: (context, index) {
                              final product = controller.featuredProducts[index];
                              return Container(
                                width: 220,
                                margin: const EdgeInsets.only(right: DimensionConstants.marginM),
                                child: ProductCard(
                                  product: product,
                                  onAddToCart: () {
                                    HapticFeedback.mediumImpact();
                                    // Add to cart functionality
                                    Get.snackbar(
                                      'Added to Cart',
                                      '${product.name} has been added to your cart',
                                      snackPosition: SnackPosition.BOTTOM,
                                      margin: const EdgeInsets.all(DimensionConstants.marginL),
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
                        ),
                      );
                    }),
                    
                    const SizedBox(height: DimensionConstants.marginXL),
                    
                    // New Arrivals
                    SectionHeader(
                      title: 'New Arrivals',
                      actionText: 'See All',
                      onActionTap: () {
                        // Navigate to new arrivals page
                      },
                    ),
                    
                    Obx(() {
                      if (controller.isLoading.value) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: DimensionConstants.paddingL,
                          ),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: DimensionConstants.marginM,
                            mainAxisSpacing: DimensionConstants.marginM,
                          ),
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return const ProductCardShimmer();
                          },
                        );
                      }
                      
                      return AnimatedFadeIn(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: DimensionConstants.paddingL,
                            vertical: DimensionConstants.paddingM,
                          ),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: DimensionConstants.marginM,
                            mainAxisSpacing: DimensionConstants.marginM,
                          ),
                          itemCount: controller.newArrivals.length,
                          itemBuilder: (context, index) {
                            final product = controller.newArrivals[index];
                            return ProductCard(
                              product: product,
                              onAddToCart: () {
                                HapticFeedback.mediumImpact();
                                // Add to cart functionality
                                Get.snackbar(
                                  'Added to Cart',
                                  '${product.name} has been added to your cart',
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: const EdgeInsets.all(DimensionConstants.marginL),
                                  backgroundColor: ColorConstants.primary,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 2),
                                );
                              },
                              onAddToWishlist: () {
                                HapticFeedback.lightImpact();
                                // Wishlist functionality
                              },
                            );
                          },
                        ),
                      );
                    }),
                    
                    const SizedBox(height: DimensionConstants.marginXXL),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}