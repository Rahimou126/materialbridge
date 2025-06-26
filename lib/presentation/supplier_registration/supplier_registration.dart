import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/business_profile_section.dart';
import './widgets/company_details_section.dart';
import './widgets/contact_information_section.dart';
import './widgets/document_upload_section.dart';
import './widgets/material_categories_section.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/terms_acceptance_section.dart';

class SupplierRegistration extends StatefulWidget {
  const SupplierRegistration({super.key});

  @override
  State<SupplierRegistration> createState() => _SupplierRegistrationState();
}

class _SupplierRegistrationState extends State<SupplierRegistration>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // Form Controllers
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _businessEmailController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _companyDescriptionController =
      TextEditingController();
  final TextEditingController _yearsInOperationController =
      TextEditingController();
  final TextEditingController _certificationsController =
      TextEditingController();

  // Form State
  String _selectedCountry = 'United States';
  List<String> _selectedCategories = [];
  List<String> _uploadedDocuments = [];
  bool _termsAccepted = false;
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;
  int _currentStep = 0;

  // Mock data for countries and categories
  final List<String> _countries = [
    'United States',
    'United Kingdom',
    'Germany',
    'France',
    'Italy',
    'Spain',
    'Canada',
    'Australia',
    'Japan',
    'South Korea',
    'China',
    'India',
    'Brazil',
    'Mexico',
    'Netherlands'
  ];

  final List<Map<String, dynamic>> _materialCategories = [
    {
      'id': 'minerals',
      'name': 'Minerals & Metals',
      'description': 'Iron ore, copper, aluminum, steel, precious metals',
      'selected': false
    },
    {
      'id': 'plastics',
      'name': 'Plastics & Polymers',
      'description': 'PVC, polyethylene, polypropylene, engineering plastics',
      'selected': false
    },
    {
      'id': 'chemicals',
      'name': 'Industrial Chemicals',
      'description': 'Solvents, acids, bases, specialty chemicals',
      'selected': false
    },
    {
      'id': 'textiles',
      'name': 'Textile Materials',
      'description': 'Cotton, synthetic fibers, dyes, finishing chemicals',
      'selected': false
    },
    {
      'id': 'electronics',
      'name': 'Electronic Components',
      'description': 'Semiconductors, circuit boards, connectors',
      'selected': false
    },
    {
      'id': 'construction',
      'name': 'Construction Materials',
      'description': 'Cement, aggregates, insulation, roofing materials',
      'selected': false
    }
  ];

  @override
  void initState() {
    super.initState();
    _setupFormListeners();
  }

  void _setupFormListeners() {
    _companyNameController.addListener(_onFormChanged);
    _registrationNumberController.addListener(_onFormChanged);
    _businessEmailController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
    _companyDescriptionController.addListener(_onFormChanged);
    _yearsInOperationController.addListener(_onFormChanged);
    _certificationsController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  bool _isFormValid() {
    return _companyNameController.text.isNotEmpty &&
        _registrationNumberController.text.isNotEmpty &&
        _businessEmailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _companyDescriptionController.text.isNotEmpty &&
        _yearsInOperationController.text.isNotEmpty &&
        _selectedCategories.isNotEmpty &&
        _termsAccepted;
  }

  void _saveDraft() {
    // Mock save draft functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Draft saved successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
    setState(() {
      _hasUnsavedChanges = false;
    });
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate() || !_isFormValid()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Mock registration process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registration successful! Welcome to MaterialBridge.'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );

    // Navigate to supplier dashboard
    Navigator.pushReplacementNamed(context, '/supplier-dashboard');
  }

  Future<bool> _onWillPop() async {
    if (_hasUnsavedChanges) {
      return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Unsaved Changes'),
              content: Text(
                  'You have unsaved changes. Are you sure you want to leave?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Stay'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Leave'),
                ),
              ],
            ),
          ) ??
          false;
    }
    return true;
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _registrationNumberController.dispose();
    _businessEmailController.dispose();
    _phoneController.dispose();
    _companyDescriptionController.dispose();
    _yearsInOperationController.dispose();
    _certificationsController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Sticky Header with Progress
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (await _onWillPop()) {
                              Navigator.pop(context);
                            }
                          },
                          child: CustomIconWidget(
                            iconName: 'arrow_back',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            'Supplier Registration',
                            style: AppTheme.lightTheme.textTheme.titleLarge,
                          ),
                        ),
                        TextButton(
                          onPressed: _hasUnsavedChanges ? _saveDraft : null,
                          child: Text('Save Draft'),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    ProgressIndicatorWidget(
                      currentStep: _currentStep,
                      totalSteps: 6,
                    ),
                  ],
                ),
              ),

              // Scrollable Form Content
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome Section
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Join MaterialBridge',
                                style: AppTheme
                                    .lightTheme.textTheme.headlineSmall
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Connect with manufacturing factories worldwide and expand your industrial material business.',
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Company Details Section
                        CompanyDetailsSection(
                          companyNameController: _companyNameController,
                          registrationNumberController:
                              _registrationNumberController,
                          selectedCountry: _selectedCountry,
                          countries: _countries,
                          onCountryChanged: (country) {
                            setState(() {
                              _selectedCountry = country;
                              _currentStep = 1;
                            });
                            _onFormChanged();
                          },
                        ),

                        SizedBox(height: 3.h),

                        // Contact Information Section
                        ContactInformationSection(
                          businessEmailController: _businessEmailController,
                          phoneController: _phoneController,
                          selectedCountry: _selectedCountry,
                          onPhoneChanged: () {
                            setState(() {
                              _currentStep = 2;
                            });
                            _onFormChanged();
                          },
                        ),

                        SizedBox(height: 3.h),

                        // Business Profile Section
                        BusinessProfileSection(
                          companyDescriptionController:
                              _companyDescriptionController,
                          yearsInOperationController:
                              _yearsInOperationController,
                          certificationsController: _certificationsController,
                          onChanged: () {
                            setState(() {
                              _currentStep = 3;
                            });
                            _onFormChanged();
                          },
                        ),

                        SizedBox(height: 3.h),

                        // Material Categories Section
                        MaterialCategoriesSection(
                          categories: _materialCategories,
                          selectedCategories: _selectedCategories,
                          onCategoryChanged: (categories) {
                            setState(() {
                              _selectedCategories = categories;
                              _currentStep = 4;
                            });
                            _onFormChanged();
                          },
                        ),

                        SizedBox(height: 3.h),

                        // Document Upload Section
                        DocumentUploadSection(
                          uploadedDocuments: _uploadedDocuments,
                          onDocumentUploaded: (documents) {
                            setState(() {
                              _uploadedDocuments = documents;
                              _currentStep = 5;
                            });
                            _onFormChanged();
                          },
                        ),

                        SizedBox(height: 3.h),

                        // Terms Acceptance Section
                        TermsAcceptanceSection(
                          termsAccepted: _termsAccepted,
                          onTermsChanged: (accepted) {
                            setState(() {
                              _termsAccepted = accepted;
                              if (accepted) _currentStep = 6;
                            });
                            _onFormChanged();
                          },
                        ),

                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Action Button
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow,
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isFormValid() && !_isLoading
                      ? _submitRegistration
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
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
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
