import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BusinessProfileSection extends StatelessWidget {
  final TextEditingController companyDescriptionController;
  final TextEditingController yearsInOperationController;
  final TextEditingController certificationsController;
  final VoidCallback onChanged;

  const BusinessProfileSection({
    super.key,
    required this.companyDescriptionController,
    required this.yearsInOperationController,
    required this.certificationsController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Profile',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        SizedBox(height: 2.h),

        // Company Description
        TextFormField(
          controller: companyDescriptionController,
          maxLines: 4,
          maxLength: 500,
          decoration: InputDecoration(
            labelText: 'Company Description *',
            hintText:
                'Describe your company, specializations, and key capabilities...',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'description',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            alignLabelWithHint: true,
          ),
          onChanged: (value) => onChanged(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Company description is required';
            }
            if (value.length < 50) {
              return 'Description must be at least 50 characters';
            }
            return null;
          },
        ),

        SizedBox(height: 2.h),

        // Years in Operation
        TextFormField(
          controller: yearsInOperationController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
          decoration: InputDecoration(
            labelText: 'Years in Operation *',
            hintText: 'Enter number of years',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'schedule',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            suffixText: 'years',
          ),
          onChanged: (value) => onChanged(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Years in operation is required';
            }
            final years = int.tryParse(value);
            if (years == null || years < 1) {
              return 'Please enter a valid number of years';
            }
            if (years > 99) {
              return 'Please enter a realistic number of years';
            }
            return null;
          },
        ),

        SizedBox(height: 2.h),

        // Certifications
        TextFormField(
          controller: certificationsController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Certifications & Standards',
            hintText:
                'ISO 9001, ISO 14001, industry-specific certifications...',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'verified',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            alignLabelWithHint: true,
          ),
          onChanged: (value) => onChanged(),
        ),

        SizedBox(height: 1.h),

        // Business Profile Tips
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'lightbulb',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Profile Tips',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                '• Highlight your unique capabilities and specializations\n'
                '• Mention key industries you serve\n'
                '• Include quality certifications and compliance standards\n'
                '• Describe your supply chain and logistics capabilities',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
