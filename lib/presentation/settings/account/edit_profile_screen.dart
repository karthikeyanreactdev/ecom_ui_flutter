import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';
import '../account/edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('Edit Profile')),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(DimensionConstants.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: DimensionConstants.spacingM),

                  // Profile picture
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: ColorConstants.surfaceVariant,
                        backgroundImage:
                            controller.profileImageFile.value != null
                                ? FileImage(controller.profileImageFile.value!)
                                : controller.user.value?.avatar != null
                                ? NetworkImage(controller.user.value!.avatar!)
                                    as ImageProvider
                                : null,
                        child:
                            controller.user.value?.avatar == null &&
                                    controller.profileImageFile.value == null
                                ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: ColorConstants.primary,
                                )
                                : null,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: InkWell(
                          onTap: () => controller.pickImage(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: ColorConstants.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    Get.isDarkMode
                                        ? ColorConstants.backgroundDark
                                        : Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: DimensionConstants.spacingL),

                  // Form fields
                  Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: controller.firstNameController,
                          label: 'First Name',
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'First name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: DimensionConstants.spacingM),

                        CustomTextField(
                          controller: controller.lastNameController,
                          label: 'Last Name',
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Last name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: DimensionConstants.spacingM),

                        CustomTextField(
                          controller: controller.emailController,
                          label: 'Email',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          readOnly: true, // Email cannot be changed
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            if (!GetUtils.isEmail(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: DimensionConstants.spacingM),

                        CustomTextField(
                          controller: controller.phoneController,
                          label: 'Phone Number',
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone number is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: DimensionConstants.spacingL),

                        CustomButton(
                          onPressed:
                              controller.isUpdating.value
                                  ? null
                                  : () => controller.updateProfile(),
                          text:
                              controller.isUpdating.value
                                  ? 'Updating...'
                                  : 'Save Changes',
                          isLoading: controller.isUpdating.value,
                          isFullWidth: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
