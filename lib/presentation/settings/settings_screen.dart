import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import 'settings_controller.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Account Settings
                  SettingsSection(
                    title: 'Account',
                    children: [
                      SettingsTile(
                        title: 'Profile Information',
                        subtitle: 'Edit your personal information',
                        icon: Icons.person_outline,
                        onTap: () => Get.toNamed('/edit-profile'),
                      ),
                      SettingsTile(
                        title: 'Address Book',
                        subtitle: 'Manage your shipping addresses',
                        icon: Icons.location_on_outlined,
                        onTap: () => Get.toNamed('/shipping-addresses'),
                      ),
                      SettingsTile(
                        title: 'Payment Methods',
                        subtitle: 'Manage your payment options',
                        icon: Icons.payment_outlined,
                        onTap: () => Get.toNamed('/payment-methods'),
                      ),
                      SettingsTile(
                        title: 'Change Password',
                        subtitle: 'Update your security credentials',
                        icon: Icons.lock_outline,
                        onTap: () => Get.toNamed('/change-password'),
                      ),
                    ],
                  ),

                  // Appearance Settings
                  SettingsSection(
                    title: 'Appearance',
                    children: [
                      SettingsSwitchTile(
                        title: 'Dark Mode',
                        subtitle: 'Switch between light and dark themes',
                        icon: Icons.dark_mode_outlined,
                        value: controller.isDarkMode.value,
                        onChanged: controller.toggleDarkMode,
                      ),
                      SettingsTile(
                        title: 'Language',
                        subtitle: controller.selectedLanguage.value,
                        icon: Icons.language_outlined,
                        trailing: DropdownButton<String>(
                          value: controller.selectedLanguage.value,
                          underline: const SizedBox.shrink(),
                          icon: const Icon(Icons.arrow_drop_down),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              controller.setLanguage(newValue);
                            }
                          },
                          items:
                              controller.availableLanguages
                                  .map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  })
                                  .toList(),
                        ),
                        onTap: null,
                      ),
                      SettingsTile(
                        title: 'Currency',
                        subtitle: controller.selectedCurrency.value,
                        icon: Icons.attach_money,
                        trailing: DropdownButton<String>(
                          value: controller.selectedCurrency.value,
                          underline: const SizedBox.shrink(),
                          icon: const Icon(Icons.arrow_drop_down),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              controller.setCurrency(newValue);
                            }
                          },
                          items:
                              controller.availableCurrencies
                                  .map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  })
                                  .toList(),
                        ),
                        onTap: null,
                      ),
                    ],
                  ),

                  // Notification Settings
                  SettingsSection(
                    title: 'Notifications',
                    children: [
                      SettingsSwitchTile(
                        title: 'Push Notifications',
                        subtitle: 'Receive notifications on your device',
                        icon: Icons.notifications_outlined,
                        value: controller.pushNotificationsEnabled.value,
                        onChanged: controller.togglePushNotifications,
                      ),
                      SettingsSwitchTile(
                        title: 'Email Notifications',
                        subtitle: 'Receive notifications via email',
                        icon: Icons.email_outlined,
                        value: controller.emailNotificationsEnabled.value,
                        onChanged: controller.toggleEmailNotifications,
                      ),
                    ],
                  ),

                  // Security Settings
                  SettingsSection(
                    title: 'Security',
                    children: [
                      SettingsSwitchTile(
                        title: 'Biometric Authentication',
                        subtitle: 'Use fingerprint or face ID to log in',
                        icon: Icons.fingerprint,
                        value: controller.biometricAuthEnabled.value,
                        onChanged: controller.toggleBiometricAuth,
                      ),
                      SettingsTile(
                        title: 'Privacy Settings',
                        subtitle: 'Manage your data privacy preferences',
                        icon: Icons.security_outlined,
                        onTap: () => Get.toNamed('/privacy-settings'),
                      ),
                    ],
                  ),

                  // Support Settings
                  SettingsSection(
                    title: 'Support',
                    children: [
                      SettingsTile(
                        title: 'Help Center',
                        subtitle: 'Get help with your orders and account',
                        icon: Icons.help_outline,
                        onTap: () => Get.toNamed('/help-center'),
                      ),
                      SettingsTile(
                        title: 'Contact Us',
                        subtitle: 'Reach our customer support team',
                        icon: Icons.support_agent_outlined,
                        onTap: () => Get.toNamed('/contact-us'),
                      ),
                      SettingsTile(
                        title: 'About',
                        subtitle: 'App version, terms, and policies',
                        icon: Icons.info_outline,
                        onTap: () => Get.toNamed('/about'),
                      ),
                    ],
                  ),

                  // Advanced Settings
                  SettingsSection(
                    title: 'Advanced',
                    children: [
                      SettingsTile(
                        title: 'Clear Cache',
                        subtitle: 'Free up storage space',
                        icon: Icons.cleaning_services_outlined,
                        onTap: controller.clearCache,
                      ),
                      SettingsTile(
                        title: 'Logout',
                        subtitle: 'Sign out from your account',
                        icon: Icons.logout,
                        iconColor: ColorConstants.warning,
                        onTap: controller.logout,
                      ),
                      SettingsTile(
                        title: 'Delete Account',
                        subtitle: 'Permanently remove your account and data',
                        icon: Icons.delete_outline,
                        isDestructive: true,
                        onTap: controller.deleteAccount,
                      ),
                    ],
                  ),

                  const SizedBox(height: DimensionConstants.paddingL),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
