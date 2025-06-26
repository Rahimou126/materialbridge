import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContactInformationSection extends StatelessWidget {
  final TextEditingController businessEmailController;
  final TextEditingController phoneController;
  final String selectedCountry;
  final VoidCallback onPhoneChanged;

  const ContactInformationSection({
    super.key,
    required this.businessEmailController,
    required this.phoneController,
    required this.selectedCountry,
    required this.onPhoneChanged,
  });

  String _getCountryCode(String country) {
    final Map<String, String> countryCodes = {
      'United States': '+1',
      'United Kingdom': '+44',
      'Germany': '+49',
      'France': '+33',
      'Italy': '+39',
      'Spain': '+34',
      'Canada': '+1',
      'Australia': '+61',
      'Japan': '+81',
      'South Korea': '+82',
      'China': '+86',
      'India': '+91',
      'Brazil': '+55',
      'Mexico': '+52',
      'Netherlands': '+31',
    };
    return countryCodes[country] ?? '+1';
  }

  String _getPhoneFormat(String country) {
    final Map<String, String> phoneFormats = {
      'United States': '(XXX) XXX-XXXX',
      'United Kingdom': 'XXXX XXX XXXX',
      'Germany': 'XXX XXXXXXXX',
      'France': 'XX XX XX XX XX',
      'Italy': 'XXX XXX XXXX',
      'Spain': 'XXX XXX XXX',
      'Canada': '(XXX) XXX-XXXX',
      'Australia': 'XXXX XXX XXX',
      'Japan': 'XX-XXXX-XXXX',
      'South Korea': 'XX-XXXX-XXXX',
      'China': 'XXX XXXX XXXX',
      'India': 'XXXXX XXXXX',
      'Brazil': '(XX) XXXXX-XXXX',
      'Mexico': 'XX XXXX XXXX',
      'Netherlands': 'XX XXX XXXX',
    };
    return phoneFormats[country] ?? '(XXX) XXX-XXXX';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        SizedBox(height: 2.h),

        // Business Email
        TextFormField(
          controller: businessEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Business Email *',
            hintText: 'Enter your business email',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'email',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Business email is required';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),

        SizedBox(height: 2.h),

        // Phone Number with Country Code
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country Code
            SizedBox(
              width: 20.w,
              child: TextFormField(
                initialValue: _getCountryCode(selectedCountry),
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Code',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'phone',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            SizedBox(width: 2.w),

            // Phone Number
            Expanded(
              child: TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
                decoration: InputDecoration(
                  labelText: 'Phone Number *',
                  hintText: _getPhoneFormat(selectedCountry),
                ),
                onChanged: (value) => onPhoneChanged(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  if (value.length < 7) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),

        SizedBox(height: 1.h),

        // Phone Format Helper
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Format for $selectedCountry: ${_getPhoneFormat(selectedCountry)}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
