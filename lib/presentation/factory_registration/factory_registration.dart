import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/business_details_section_widget.dart';
import './widgets/company_info_section_widget.dart';
import './widgets/contact_details_section_widget.dart';
import './widgets/profile_photo_section_widget.dart';

class FactoryRegistration extends StatefulWidget {
  const FactoryRegistration({super.key});

  @override
  State<FactoryRegistration> createState() => _FactoryRegistrationState();
}

class _FactoryRegistrationState extends State<FactoryRegistration> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form controllers
  final _companyNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _businessEmailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Form state
  String? _selectedIndustryType;
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCompanySize;
  String? _selectedCountryCode;
  final List<String> _selectedMaterials = [];
  String? _profileImagePath;
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  // Mock data
  final List<String> _industryTypes = [
    'Automotive Manufacturing',
    'Electronics & Technology',
    'Textile & Apparel',
    'Food & Beverage Processing',
    'Chemical Processing',
    'Pharmaceutical',
    'Construction Materials',
    'Metal Fabrication',
    'Plastic Manufacturing',
    'Packaging',
    'Aerospace',
    'Medical Devices'
  ];

  final List<String> _countries = [
    'United States',
    'United Kingdom',
    'Germany',
    'France',
    'India',
    'China',
    'Japan',
    'Canada',
    'Australia',
    'Brazil'
  ];

  final Map<String, List<String>> _statesByCountry = {
    'United States': ['California', 'Texas', 'New York', 'Florida', 'Illinois'],
    'United Kingdom': ['England', 'Scotland', 'Wales', 'Northern Ireland'],
    'Germany': [
      'Bavaria',
      'North Rhine-Westphalia',
      'Baden-Württemberg',
      'Lower Saxony'
    ],
    'India': [
      'Maharashtra',
      'Gujarat',
      'Tamil Nadu',
      'Karnataka',
      'Uttar Pradesh'
    ],
    'China': ['Guangdong', 'Jiangsu', 'Shandong', 'Zhejiang', 'Henan'],
  };

  final List<String> _companySizes = [
    'Small Workshop (1-10 employees)',
    'Small Business (11-50 employees)',
    'Medium Enterprise (51-200 employees)',
    'Large Corporation (201-1000 employees)',
    'Enterprise (1000+ employees)'
  ];

  final List<String> _materialCategories = [
    'Metals & Alloys',
    'Plastics & Polymers',
    'Chemicals & Compounds',
    'Textiles & Fabrics',
    'Ceramics & Glass',
    'Composites',
    'Rubber & Elastomers',
    'Wood & Paper',
    'Electronic Components',
    'Adhesives & Sealants'
  ];

  final List<Map<String, String>> _countryCodes = [
    {'code': '+1', 'country': 'US/CA'},
    {'code': '+44', 'country': 'UK'},
    {'code': '+49', 'country': 'DE'},
    {'code': '+33', 'country': 'FR'},
    {'code': '+91', 'country': 'IN'},
    {'code': '+86', 'country': 'CN'},
    {'code': '+81', 'country': 'JP'},
    {'code': '+61', 'country': 'AU'},
    {'code': '+55', 'country': 'BR'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = '+1';

    // Add listeners to track changes
    _companyNameController.addListener(_onFormChanged);
    _contactPersonController.addListener(_onFormChanged);
    _businessEmailController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
    _websiteController.addListener(_onFormChanged);
    _descriptionController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _contactPersonController.dispose();
    _businessEmailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  void _onIndustryTypeChanged(String? value) {
    setState(() {
      _selectedIndustryType = value;
      _hasUnsavedChanges = true;
    });
  }

  void _onCountryChanged(String? value) {
    setState(() {
      _selectedCountry = value;
      _selectedState = null; // Reset state when country changes
      _hasUnsavedChanges = true;
    });
  }

  void _onStateChanged(String? value) {
    setState(() {
      _selectedState = value;
      _hasUnsavedChanges = true;
    });
  }

  void _onCompanySizeChanged(String? value) {
    setState(() {
      _selectedCompanySize = value;
      _hasUnsavedChanges = true;
    });
  }

  void _onCountryCodeChanged(String? value) {
    setState(() {
      _selectedCountryCode = value;
      _hasUnsavedChanges = true;
    });
  }

  void _onMaterialToggle(String material) {
    setState(() {
      if (_selectedMaterials.contains(material)) {
        _selectedMaterials.remove(material);
      } else {
        _selectedMaterials.add(material);
      }
      _hasUnsavedChanges = true;
    });
  }

  void _onProfileImageSelected(String? imagePath) {
    setState(() {
      _profileImagePath = imagePath;
      _hasUnsavedChanges = true;
    });
  }

  bool _isFormValid() {
    return _companyNameController.text.isNotEmpty &&
        _selectedIndustryType != null &&
        _selectedCountry != null &&
        _selectedState != null &&
        _contactPersonController.text.isNotEmpty &&
        _businessEmailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _selectedCompanySize != null &&
        _selectedMaterials.isNotEmpty;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Business email is required';
    }

    // Basic email validation
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    // Domain validation for business emails
    final commonPersonalDomains = [
      'gmail.com',
      'yahoo.com',
      'hotmail.com',
      'outlook.com'
    ];
    final domain = value.split('@').last.toLowerCase();
    if (commonPersonalDomains.contains(domain)) {
      return 'Please use a business email address';
    }

    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove spaces and special characters for validation
    final cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.length < 7 || cleanPhone.length > 15) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  String? _validateWebsite(String? value) {
    if (value != null && value.isNotEmpty) {
      final urlRegex = RegExp(r'^https?:\/\/[^\s/$.?#].[^\s]*$');
      if (!urlRegex.hasMatch(value)) {
        return 'Please enter a valid website URL';
      }
    }
    return null;
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate() || !_isFormValid()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Welcome to MaterialBridge! Your factory account has been created successfully.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onInverseSurface,
              ),
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            duration: const Duration(seconds: 3),
          ),
        );

        // Navigate to marketplace or dashboard
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/supplier-dashboard', // This would be factory dashboard in real app
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Registration failed. Please try again.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onError,
              ),
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Discard Changes?',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'You have unsaved changes. Are you sure you want to go back?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Factory Registration',
            style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
          ),
          leading: IconButton(
            onPressed: () async {
              if (_hasUnsavedChanges) {
                final shouldPop = await _onWillPop();
                if (shouldPop && mounted) {
                  Navigator.of(context).pop();
                }
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
          elevation: AppTheme.lightTheme.appBarTheme.elevation,
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Create Your Factory Account',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Join MaterialBridge to connect with suppliers and streamline your material sourcing process.',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Profile Photo Section
                  ProfilePhotoSectionWidget(
                    profileImagePath: _profileImagePath,
                    onImageSelected: _onProfileImageSelected,
                  ),
                  SizedBox(height: 3.h),

                  // Company Information Section
                  CompanyInfoSectionWidget(
                    companyNameController: _companyNameController,
                    selectedIndustryType: _selectedIndustryType,
                    industryTypes: _industryTypes,
                    onIndustryTypeChanged: _onIndustryTypeChanged,
                    selectedCountry: _selectedCountry,
                    countries: _countries,
                    onCountryChanged: _onCountryChanged,
                    selectedState: _selectedState,
                    states: _selectedCountry != null
                        ? _statesByCountry[_selectedCountry!] ?? []
                        : [],
                    onStateChanged: _onStateChanged,
                  ),
                  SizedBox(height: 3.h),

                  // Contact Details Section
                  ContactDetailsSectionWidget(
                    contactPersonController: _contactPersonController,
                    businessEmailController: _businessEmailController,
                    phoneController: _phoneController,
                    selectedCountryCode: _selectedCountryCode,
                    countryCodes: _countryCodes,
                    onCountryCodeChanged: _onCountryCodeChanged,
                    validateEmail: _validateEmail,
                    validatePhone: _validatePhone,
                  ),
                  SizedBox(height: 3.h),

                  // Business Details Section
                  BusinessDetailsSectionWidget(
                    selectedCompanySize: _selectedCompanySize,
                    companySizes: _companySizes,
                    onCompanySizeChanged: _onCompanySizeChanged,
                    selectedMaterials: _selectedMaterials,
                    materialCategories: _materialCategories,
                    onMaterialToggle: _onMaterialToggle,
                    websiteController: _websiteController,
                    descriptionController: _descriptionController,
                    validateWebsite: _validateWebsite,
                  ),
                  SizedBox(height: 4.h),

                  // Create Account Button
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                      onPressed: _isFormValid() && !_isLoading
                          ? _handleRegistration
                          : null,
                      style: AppTheme.lightTheme.elevatedButtonTheme.style
                          ?.copyWith(
                        backgroundColor:
                            WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.disabled)) {
                            return AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.3);
                          }
                          return AppTheme.lightTheme.colorScheme.primary;
                        }),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : Text(
                              'Create Account',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Login Link
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login-screen');
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
