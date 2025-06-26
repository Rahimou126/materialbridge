import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContactDetailsSectionWidget extends StatelessWidget {
  final TextEditingController contactPersonController;
  final TextEditingController businessEmailController;
  final TextEditingController phoneController;
  final String? selectedCountryCode;
  final List<Map<String, String>> countryCodes;
  final ValueChanged<String?> onCountryCodeChanged;
  final String? Function(String?) validateEmail;
  final String? Function(String?) validatePhone;

  const ContactDetailsSectionWidget({
    super.key,
    required this.contactPersonController,
    required this.businessEmailController,
    required this.phoneController,
    required this.selectedCountryCode,
    required this.countryCodes,
    required this.onCountryCodeChanged,
    required this.validateEmail,
    required this.validatePhone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Details',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),

        // Contact Person
        TextFormField(
          controller: contactPersonController,
          decoration: InputDecoration(
            labelText: 'Contact Person *',
            hintText: 'Enter contact person name',
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Contact person name is required';
            }
            if (value.trim().length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
        ),
        SizedBox(height: 2.h),

        // Business Email
        TextFormField(
          controller: businessEmailController,
          decoration: InputDecoration(
            labelText: 'Business Email *',
            hintText: 'Enter business email address',
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomIconWidget(
                iconName: 'email',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            helperText: 'Please use your company email address',
            helperStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          validator: validateEmail,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autocorrect: false,
        ),
        SizedBox(height: 2.h),

        // Phone Number with Country Code
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country Code Dropdown
            SizedBox(
              width: 25.w,
              child: DropdownButtonFormField<String>(
                value: selectedCountryCode,
                decoration: InputDecoration(
                  labelText: 'Code',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                items: countryCodes.map((Map<String, String> code) {
                  return DropdownMenuItem<String>(
                    value: code['code'],
                    child: Text(
                      '${code['code']} ${code['country']}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: onCountryCodeChanged,
                isExpanded: true,
                menuMaxHeight: 30.h,
              ),
            ),
            SizedBox(width: 2.w),
            // Phone Number Field
            Expanded(
              child: TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number *',
                  hintText: 'Enter phone number',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CustomIconWidget(
                      iconName: 'phone',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
                validator: validatePhone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
