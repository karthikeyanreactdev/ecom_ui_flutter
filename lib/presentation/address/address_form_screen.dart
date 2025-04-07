import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import 'address_form_controller.dart';

class AddressFormScreen extends StatelessWidget {
  final bool isEditing;

  const AddressFormScreen({super.key, this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressFormController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(isEditing ? 'Edit Address' : 'Add New Address'),
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(DimensionConstants.paddingM),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: DimensionConstants.spacingM),

                    CustomTextField(
                      controller: controller.nameController,
                      label: 'Full Name',
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
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
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: DimensionConstants.spacingL),
                    const Text(
                      'Address Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: DimensionConstants.spacingM),

                    CustomTextField(
                      controller: controller.addressLine1Controller,
                      label: 'Address Line 1',
                      prefixIcon: Icons.location_on_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your street address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: DimensionConstants.spacingM),

                    CustomTextField(
                      controller: controller.addressLine2Controller,
                      label: 'Address Line 2 (Optional)',
                      prefixIcon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: DimensionConstants.spacingM),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: controller.cityController,
                            label: 'City',
                            prefixIcon: Icons.location_city_outlined,

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: DimensionConstants.spacingM),
                        Expanded(
                          child: CustomTextField(
                            controller: controller.stateController,
                            label: 'State/Province',
                            prefixIcon: Icons.map_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DimensionConstants.spacingM),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: controller.postalCodeController,
                            label: 'Postal Code',
                            prefixIcon: Icons.mail_outline,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: DimensionConstants.spacingM),
                        Expanded(
                          child: CustomTextField(
                            controller: controller.countryController,
                            label: 'Country',
                            prefixIcon: Icons.public_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: DimensionConstants.spacingL),
                    CheckboxListTile(
                      value: controller.isDefault.value,
                      onChanged:
                          (value) =>
                              controller.isDefault.value = value ?? false,
                      title: const Text('Set as default shipping address'),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: ColorConstants.primary,
                    ),

                    const SizedBox(height: DimensionConstants.spacingL),
                    CustomButton(
                      onPressed:
                          controller.isSaving.value
                              ? null
                              : () => controller.saveAddress(),
                      text:
                          controller.isSaving.value
                              ? 'Saving...'
                              : (isEditing ? 'Update Address' : 'Save Address'),
                      isLoading: controller.isSaving.value,
                      isFullWidth: true,
                    ),
                    const SizedBox(height: DimensionConstants.spacingM),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
