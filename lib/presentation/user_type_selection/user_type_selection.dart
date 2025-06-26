import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/user_type_card_widget.dart';

class UserTypeSelection extends StatefulWidget {
  const UserTypeSelection({super.key});

  @override
  State<UserTypeSelection> createState() => _UserTypeSelectionState();
}

class _UserTypeSelectionState extends State<UserTypeSelection> {
  String? selectedUserType;

  void _selectUserType(String userType) {
    setState(() {
      selectedUserType = userType;
    });
    HapticFeedback.lightImpact();
  }

  void _onContinue() {
    if (selectedUserType == null) return;

    HapticFeedback.mediumImpact();

    if (selectedUserType == 'supplier') {
      Navigator.pushNamed(context, '/supplier-registration');
    } else {
      Navigator.pushNamed(context, '/factory-registration');
    }
  }

  void _showLearnMore(String userType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LearnMoreBottomSheet(userType: userType),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            children: [
              SizedBox(height: 4.h),

              // App Logo Section
              Container(
                width: 25.w,
                height: 25.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(4.w),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'MB',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              Text(
                'MaterialBridge',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 1.h),

              Text(
                'Choose your role to get started',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 6.h),

              // User Type Cards
              UserTypeCardWidget(
                userType: 'supplier',
                title: 'List & Sell Materials',
                subtitle: 'Industrial Material Supplier',
                imageUrl:
                    'https://images.pexels.com/photos/1267338/pexels-photo-1267338.jpeg?auto=compress&cs=tinysrgb&w=800',
                features: const [
                  'Manage inventory listings',
                  'Handle purchase requests',
                  'Subscription benefits',
                  'Direct factory communication',
                ],
                isSelected: selectedUserType == 'supplier',
                onTap: () => _selectUserType('supplier'),
                onLearnMore: () => _showLearnMore('supplier'),
              ),

              SizedBox(height: 3.h),

              UserTypeCardWidget(
                userType: 'factory',
                title: 'Source Materials',
                subtitle: 'Manufacturing Factory',
                imageUrl:
                    'https://images.pixabay.com/photo/2016/11/19/11/26/factory-1838104_960_720.jpg',
                features: const [
                  'Browse material catalog',
                  'Advanced filtering options',
                  'Procurement management',
                  'Technical specifications',
                ],
                isSelected: selectedUserType == 'factory',
                onTap: () => _selectUserType('factory'),
                onLearnMore: () => _showLearnMore('factory'),
              ),

              SizedBox(height: 6.h),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: selectedUserType != null ? _onContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedUserType != null
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.3),
                    foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                    elevation: selectedUserType != null ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 3.h),

              // Login Link
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/login-screen'),
                child: Text(
                  'Already have an account? Login',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _LearnMoreBottomSheet extends StatelessWidget {
  final String userType;

  const _LearnMoreBottomSheet({required this.userType});

  @override
  Widget build(BuildContext context) {
    final isSupplier = userType == 'supplier';

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(1.w),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSupplier
                        ? 'Material Supplier Role'
                        : 'Manufacturing Factory Role',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    isSupplier
                        ? 'As a Material Supplier, you can showcase your industrial materials to manufacturing factories worldwide. Build your digital catalog, manage inventory, and connect directly with potential buyers.'
                        : 'As a Manufacturing Factory, you gain access to a comprehensive marketplace of industrial materials. Find suppliers, compare specifications, and streamline your procurement process.',
                    style: AppTheme.lightTheme.textTheme.bodyLarge,
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Key Features:',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  ...(_getFeaturesList(isSupplier).map((feature) => Padding(
                        padding: EdgeInsets.only(bottom: 1.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 0.5.h, right: 3.w),
                              width: 1.w,
                              height: 1.w,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                feature,
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ))),
                  SizedBox(height: 3.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(2.w),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Getting Started:',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          isSupplier
                              ? 'Complete your supplier profile, add your first material listings, and start receiving purchase requests from factories.'
                              : 'Set up your factory profile, explore the material catalog, and begin sourcing materials for your manufacturing needs.',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Close Button
          Padding(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Got it',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getFeaturesList(bool isSupplier) {
    if (isSupplier) {
      return [
        'Create detailed material listings with specifications',
        'Upload technical data sheets and product images',
        'Manage inventory status and availability',
        'Receive and respond to purchase requests',
        'Set pricing and quantity information',
        'Track request history and communications',
        'Access subscription benefits and premium features',
        'Build your supplier reputation and ratings',
      ];
    } else {
      return [
        'Browse comprehensive material catalog',
        'Use advanced filtering by category, location, and specs',
        'View detailed technical specifications',
        'Submit purchase requests with requirements',
        'Communicate directly with suppliers',
        'Save favorite materials and suppliers',
        'Track procurement history and orders',
        'Access technical blog and industry insights',
      ];
    }
  }
}
