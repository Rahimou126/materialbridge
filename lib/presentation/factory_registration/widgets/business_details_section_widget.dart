import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BusinessDetailsSectionWidget extends StatelessWidget {
  final String? selectedCompanySize;
  final List<String> companySizes;
  final ValueChanged<String?> onCompanySizeChanged;
  final List<String> selectedMaterials;
  final List<String> materialCategories;
  final ValueChanged<String> onMaterialToggle;
  final TextEditingController websiteController;
  final TextEditingController descriptionController;
  final String? Function(String?) validateWebsite;

  const BusinessDetailsSectionWidget({
    super.key,
    required this.selectedCompanySize,
    required this.companySizes,
    required this.onCompanySizeChanged,
    required this.selectedMaterials,
    required this.materialCategories,
    required this.onMaterialToggle,
    required this.websiteController,
    required this.descriptionController,
    required this.validateWebsite,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Details',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),

        // Company Size
        DropdownButtonFormField<String>(
          value: selectedCompanySize,
          decoration: InputDecoration(
            labelText: 'Company Size *',
            hintText: 'Select company size',
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomIconWidget(
                iconName: 'groups',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          items: companySizes.map((String size) {
            return DropdownMenuItem<String>(
              value: size,
              child: Text(
                size,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onCompanySizeChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select your company size';
            }
            return null;
          },
          isExpanded: true,
          menuMaxHeight: 40.h,
        ),
        SizedBox(height: 2.h),

        // Primary Materials of Interest
        Text(
          'Primary Materials of Interest *',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Select the material categories you typically source for your manufacturing processes.',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),

        // Material Categories Chips
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: materialCategories.map((String material) {
            final isSelected = selectedMaterials.contains(material);
            return FilterChip(
              label: Text(
                material,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onMaterialToggle(material),
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              selectedColor: AppTheme.lightTheme.colorScheme.primary,
              checkmarkColor: AppTheme.lightTheme.colorScheme.onPrimary,
              side: BorderSide(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline,
                width: 1.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }).toList(),
        ),

        // Validation message for materials
        if (selectedMaterials.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Text(
              'Please select at least one material category',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),

        SizedBox(height: 2.h),

        // Optional Fields Section
        Text(
          'Additional Information (Optional)',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),

        // Company Website
        TextFormField(
          controller: websiteController,
          decoration: InputDecoration(
            labelText: 'Company Website',
            hintText: 'https://www.yourcompany.com',
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomIconWidget(
                iconName: 'language',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          validator: validateWebsite,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.next,
          autocorrect: false,
        ),
        SizedBox(height: 2.h),

        // Company Description
        TextFormField(
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: 'Manufacturing Focus',
            hintText:
                'Brief description of your manufacturing focus and capabilities...',
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomIconWidget(
                iconName: 'description',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            alignLabelWithHint: true,
          ),
          maxLines: 4,
          maxLength: 500,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }
}
