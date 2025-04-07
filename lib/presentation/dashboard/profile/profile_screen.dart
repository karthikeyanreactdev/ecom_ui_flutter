import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';
import '../../../widgets/custom_button.dart';
import 'profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({Key? key}) : super(key: key);

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
    final dividerColor =
        isDarkMode ? ColorConstants.dividerDark : ColorConstants.dividerLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            SliverAppBar(
              title: const Text('My Profile'),
              floating: true,
              backgroundColor: backgroundColor,
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: controller.navigateToSettings,
                ),
              ],
            ),

            // Profile content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(DimensionConstants.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User info card
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.all(
                          DimensionConstants.paddingL,
                        ),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(
                            DimensionConstants.radiusL,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Profile image
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    isDarkMode
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade200,
                              ),
                              child:
                                  controller.isLoggedIn.value &&
                                          controller.user.value?.avatar !=
                                              null
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: Image.network(
                                          controller.user.value!.avatar!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Icon(
                                              Icons.person,
                                              size: 40,
                                              color:
                                                  isDarkMode
                                                      ? Colors.grey.shade600
                                                      : Colors.grey.shade400,
                                            );
                                          },
                                        ),
                                      )
                                      : Icon(
                                        Icons.person,
                                        size: 40,
                                        color:
                                            isDarkMode
                                                ? Colors.grey.shade600
                                                : Colors.grey.shade400,
                                      ),
                            ),

                            const SizedBox(width: DimensionConstants.marginL),

                            // User info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (controller.isLoggedIn.value &&
                                      controller.user.value != null) ...[
                                    Text(
                                      controller.user.value!.name,
                                      style: TextStyle(
                                        fontSize: DimensionConstants.textXL,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: DimensionConstants.marginXS,
                                    ),
                                    Text(
                                      controller.user.value!.email,
                                      style: TextStyle(
                                        fontSize: DimensionConstants.textM,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                    if (controller.user.value!.phone !=
                                        null) ...[
                                      const SizedBox(
                                        height: DimensionConstants.marginXS,
                                      ),
                                      Text(
                                        controller.user.value!.phone!,
                                        style: TextStyle(
                                          fontSize: DimensionConstants.textM,
                                          color: secondaryTextColor,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(
                                      height: DimensionConstants.marginM,
                                    ),
                                    CustomButton(
                                      text: 'Edit Profile',
                                      isOutlined: true,
                                      onPressed:
                                          controller.navigateToEditProfile,
                                    ),
                                  ] else ...[
                                    Text(
                                      'Guest User',
                                      style: TextStyle(
                                        fontSize: DimensionConstants.textXL,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: DimensionConstants.marginXS,
                                    ),
                                    Text(
                                      'Sign in to access your account',
                                      style: TextStyle(
                                        fontSize: DimensionConstants.textM,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: DimensionConstants.marginM,
                                    ),
                                    CustomButton(
                                      text: 'Sign In',
                                      onPressed: controller.navigateToLogin,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: DimensionConstants.marginXL),

                    // My Account section
                    Text(
                      'My Account',
                      style: TextStyle(
                        fontSize: DimensionConstants.textL,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: DimensionConstants.marginM),

                    // Account menu
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(
                          DimensionConstants.radiusL,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem(
                            context: context,
                            icon: Icons.shopping_bag_outlined,
                            title: 'My Orders',
                            onTap: controller.navigateToOrders,
                            dividerColor: dividerColor,
                          ),
                          _buildMenuItem(
                            context: context,
                            icon: Icons.favorite_border,
                            title: 'Wishlist',
                            onTap: controller.navigateToWishlist,
                            dividerColor: dividerColor,
                          ),
                          _buildMenuItem(
                            context: context,
                            icon: Icons.location_on_outlined,
                            title: 'Addresses',
                            onTap: controller.navigateToAddresses,
                            dividerColor: dividerColor,
                          ),
                          _buildMenuItem(
                            context: context,
                            icon: Icons.payment_outlined,
                            title: 'Payment Methods',
                            onTap: controller.navigateToPaymentMethods,
                            dividerColor: dividerColor,
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: DimensionConstants.marginXL),

                    // App Settings section
                    Text(
                      'App Settings',
                      style: TextStyle(
                        fontSize: DimensionConstants.textL,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: DimensionConstants.marginM),

                    // Settings menu
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(
                          DimensionConstants.radiusL,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem(
                            context: context,
                            icon: Icons.language_outlined,
                            title: 'Language',
                            onTap: () {
                              // Show language selection
                            },
                            dividerColor: dividerColor,
                            trailing: Text(
                              'English',
                              style: TextStyle(
                                fontSize: DimensionConstants.textS,
                                color: secondaryTextColor,
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            context: context,
                            icon: Icons.dark_mode_outlined,
                            title: 'Dark Mode',
                            onTap: () {},
                            dividerColor: dividerColor,
                            showTrailingIcon: false,
                            trailing: Obx(
                              () => Switch(
                                value: controller.isDarkMode.value,
                                onChanged: (value) {
                                  HapticFeedback.lightImpact();
                                  controller.toggleDarkMode(value);
                                },
                                activeColor: ColorConstants.primary,
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            context: context,
                            icon: Icons.notifications_outlined,
                            title: 'Notifications',
                            onTap: () {
                              Get.toNamed('/notifications');
                            },
                            dividerColor: dividerColor,
                          ),
                          _buildMenuItem(
                            context: context,
                            icon: Icons.help_outline,
                            title: 'Help & Support',
                            onTap: controller.navigateToHelp,
                            dividerColor: dividerColor,
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: DimensionConstants.marginXL),

                    // Logout button (if logged in)
                    Obx(
                      () =>
                          controller.isLoggedIn.value
                              ? Center(
                                child: CustomButton(
                                  text: 'Log Out',
                                  isOutlined: true,
                                  onPressed: controller.logout,
                                  icon: Icons.logout,
                                ),
                              )
                              : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: DimensionConstants.marginXXL),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color dividerColor,
    bool showDivider = true,
    bool showTrailingIcon = true,
    Widget? trailing,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode
            ? ColorConstants.textPrimaryDark
            : ColorConstants.textPrimaryLight;

    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: ColorConstants.primary,
            size: DimensionConstants.iconM,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: DimensionConstants.textM,
              color: textColor,
            ),
          ),
          trailing:
              trailing ??
              (showTrailingIcon
                  ? const Icon(
                    Icons.arrow_forward_ios,
                    size: DimensionConstants.iconXS,
                  )
                  : null),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            color: dividerColor,
            height: 1,
            indent: DimensionConstants.marginXL + DimensionConstants.marginL,
            endIndent: DimensionConstants.marginL,
          ),
      ],
    );
  }
}
