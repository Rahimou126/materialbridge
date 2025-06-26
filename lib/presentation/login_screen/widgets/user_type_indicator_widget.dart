import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UserTypeIndicatorWidget extends StatelessWidget {
  final String selectedUserType;
  final VoidCallback onUserTypeChanged;

  const UserTypeIndicatorWidget({
    super.key,
    required this.selectedUserType,
    required this.onUserTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Login as',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: selectedUserType == 'Supplier'
                        ? AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(1.5.w),
                    border: Border.all(
                      color: selectedUserType == 'Supplier'
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: selectedUserType == 'Supplier' ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'business',
                        color: selectedUserType == 'Supplier'
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 6.w,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Supplier',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: selectedUserType == 'Supplier'
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: selectedUserType == 'Supplier'
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: selectedUserType == 'Factory'
                        ? AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(1.5.w),
                    border: Border.all(
                      color: selectedUserType == 'Factory'
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: selectedUserType == 'Factory' ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'factory',
                        color: selectedUserType == 'Factory'
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 6.w,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Factory',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: selectedUserType == 'Factory'
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: selectedUserType == 'Factory'
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Center(
            child: GestureDetector(
              onTap: onUserTypeChanged,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(1.w),
                  border: Border.all(
                    color: AppTheme.lightTheme.primaryColor,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'swap_horiz',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Switch User Type',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
