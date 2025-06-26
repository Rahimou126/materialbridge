import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CompanyInfoSectionWidget extends StatelessWidget {
  final TextEditingController companyNameController;
  final String? selectedIndustryType;
  final List<String> industryTypes;
  final ValueChanged<String?> onIndustryTypeChanged;
  final String? selectedCountry;
  final List<String> countries;
  final ValueChanged<String?> onCountryChanged;
  final String? selectedState;
  final List<String> states;
  final ValueChanged<String?> onStateChanged;

  const CompanyInfoSectionWidget({
    super.key,
    required this.companyNameController,
    required this.selectedIndustryType,
    required this.industryTypes,
    required this.onIndustryTypeChanged,
    required this.selectedCountry,
    required this.countries,
    required this.onCountryChanged,
    required this.selectedState,
    required this.states,
    required this.onStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Company Information',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),

        // Company Name
        TextFormField(
          controller: companyNameController,
          decoration: InputDecoration(
            labelText: 'Company Name *',
            hintText: 'Enter your company name',
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomIconWidget(
                iconName: 'business',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Company name is required';
            }
            if (value.trim().length < 2) {
              return 'Company name must be at least 2 characters';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 2.h),

        // Industry Type Dropdown
        DropdownButtonFormField<String>(
          value: selectedIndustryType,
          decoration: InputDecoration(
            labelText: 'Industry Type *',
            hintText: 'Select your industry',
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomIconWidget(
                iconName: 'factory',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          items: industryTypes.map((String type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(
                type,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onIndustryTypeChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select your industry type';
            }
            return null;
          },
          isExpanded: true,
          menuMaxHeight: 40.h,
        ),
        SizedBox(height: 2.h),

        // Location Section
        Text(
          'Location',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),

        // Country Dropdown
        DropdownButtonFormField<String>(
          value: selectedCountry,
          decoration: InputDecoration(
            labelText: 'Country *',
            hintText: 'Select country',
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomIconWidget(
                iconName: 'public',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          items: countries.map((String country) {
            return DropdownMenuItem<String>(
              value: country,
              child: Text(
                country,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onCountryChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select your country';
            }
            return null;
          },
          isExpanded: true,
          menuMaxHeight: 40.h,
        ),
        SizedBox(height: 2.h),

        // State Dropdown
        DropdownButtonFormField<String>(
          value: selectedState,
          decoration: InputDecoration(
            labelText: 'State/Province *',
            hintText: selectedCountry != null
                ? 'Select state/province'
                : 'Select country first',
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomIconWidget(
                iconName: 'location_city',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          items: states.map((String state) {
            return DropdownMenuItem<String>(
              value: state,
              child: Text(
                state,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: states.isNotEmpty ? onStateChanged : null,
          validator: (value) {
            if (selectedCountry != null && (value == null || value.isEmpty)) {
              return 'Please select your state/province';
            }
            return null;
          },
          isExpanded: true,
          menuMaxHeight: 40.h,
        ),
      ],
    );
  }
}
