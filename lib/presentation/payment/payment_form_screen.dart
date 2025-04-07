import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import 'payment_form_controller.dart';

class PaymentFormScreen extends StatelessWidget {
  final bool isEditing;

  const PaymentFormScreen({super.key, this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentFormController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              isEditing ? 'Edit Payment Method' : 'Add Payment Method',
            ),
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
                    // Card Type Selection
                    const Text(
                      'Card Type',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: DimensionConstants.spacingM),

                    _buildCardTypeSelector(controller),

                    const SizedBox(height: DimensionConstants.spacingL),

                    // Card Details
                    const Text(
                      'Card Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: DimensionConstants.spacingM),

                    CustomTextField(
                      controller: controller.cardNumberController,
                      label: 'Card Number',
                      prefixIcon: Icons.credit_card,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                        _CardNumberFormatter(),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your card number';
                        }
                        if (value.replaceAll(' ', '').length < 16) {
                          return 'Please enter a valid card number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: DimensionConstants.spacingM),

                    CustomTextField(
                      controller: controller.cardholderNameController,
                      label: 'Cardholder Name',
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the cardholder name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: DimensionConstants.spacingM),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: controller.expiryDateController,
                            label: 'Expiry Date (MM/YY)',
                            prefixIcon: Icons.date_range_outlined,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                              _ExpiryDateFormatter(),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                                return 'Use MM/YY format';
                              }

                              // Check for valid month and year
                              final parts = value.split('/');
                              final month = int.tryParse(parts[0]);
                              if (month == null || month < 1 || month > 12) {
                                return 'Invalid month';
                              }

                              final year = int.tryParse('20${parts[1]}');
                              final currentYear = DateTime.now().year;
                              if (year == null || year < currentYear) {
                                return 'Card expired';
                              }

                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: DimensionConstants.spacingM),
                        Expanded(
                          child: CustomTextField(
                            controller: controller.cvvController,
                            label: 'CVV',
                            prefixIcon: Icons.security_outlined,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              if (value.length < 3) {
                                return 'Invalid CVV';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: DimensionConstants.spacingL),

                    // Set as Default Option
                    CheckboxListTile(
                      value: controller.isDefault.value,
                      onChanged:
                          (value) =>
                              controller.isDefault.value = value ?? false,
                      title: const Text('Set as default payment method'),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: ColorConstants.primary,
                    ),

                    const SizedBox(height: DimensionConstants.spacingL),

                    // Save Button
                    CustomButton(
                      onPressed:
                          controller.isSaving.value
                              ? null
                              : () => controller.savePaymentMethod(),
                      text:
                          controller.isSaving.value
                              ? 'Saving...'
                              : (isEditing
                                  ? 'Update Payment Method'
                                  : 'Save Payment Method'),
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

  Widget _buildCardTypeSelector(PaymentFormController controller) {
    return Obx(
      () => Wrap(
        spacing: 12,
        runSpacing: 12,
        children:
            controller.cardTypes.map((type) {
              final isSelected = type == controller.selectedCardType.value;

              return InkWell(
                onTap: () => controller.selectCardType(type),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.all(DimensionConstants.paddingM),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          isSelected
                              ? ColorConstants.primary
                              : ColorConstants.divider,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color:
                        isSelected
                            ? ColorConstants.primaryLight.withOpacity(0.1)
                            : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getCardIcon(type),
                        size: 32,
                        color:
                            isSelected
                                ? ColorConstants.primary
                                : ColorConstants.textSecondary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        type,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color:
                              isSelected
                                  ? ColorConstants.primary
                                  : ColorConstants.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  IconData _getCardIcon(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return Icons.credit_card;
      case 'mastercard':
        return Icons.credit_card;
      case 'american express':
        return Icons.credit_card;
      case 'discover':
        return Icons.credit_card;
      default:
        return Icons.credit_card;
    }
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Only format if the user is adding digits
    if (newValue.text.length <= oldValue.text.length) {
      return newValue;
    }

    // Remove all non-digits
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Format with spaces after every 4 digits
    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      buffer.write(digitsOnly[i]);
      if ((i + 1) % 4 == 0 && i != digitsOnly.length - 1) {
        buffer.write(' ');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Only format if the user is adding digits
    if (newValue.text.length <= oldValue.text.length) {
      return newValue;
    }

    // Remove all non-digits
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Format MM/YY
    String formatted = digitsOnly;
    if (digitsOnly.length > 2) {
      formatted = '${digitsOnly.substring(0, 2)}/${digitsOnly.substring(2)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
