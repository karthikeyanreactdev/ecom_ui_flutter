import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/dimension_constants.dart';
import '../../core/constants/text_constants.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import 'dashboard_controller.dart';
import 'home/home_screen.dart';
import 'categories/categories_screen.dart';
import 'cart/cart_screen.dart';
import 'profile/profile_screen.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (controller.currentIndex.value) {
          case 0:
            return const HomeScreen();
          case 1:
            return const CategoriesScreen();
          case 2:
            return const CartScreen();
          case 3:
            return const ProfileScreen();
          default:
            return const HomeScreen();
        }
      }),
      bottomNavigationBar: Obx(() => CustomBottomNavBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changePage,
        items: [
          BottomNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Home',
          ),
          BottomNavItem(
            icon: Icons.category_outlined,
            activeIcon: Icons.category_rounded,
            label: 'Categories',
          ),
          BottomNavItem(
            icon: Icons.shopping_cart_outlined,
            activeIcon: Icons.shopping_cart_rounded,
            label: 'Cart',
            badgeCount: controller.cartItemCount.value,
          ),
          BottomNavItem(
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: 'Profile',
          ),
        ],
      )),
    );
  }
}