import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_options_widget.dart';
import './widgets/availability_widget.dart';
import './widgets/image_upload_widget.dart';
import './widgets/material_form_widget.dart';
import './widgets/technical_specs_widget.dart';

class MaterialListingCreation extends StatefulWidget {
  const MaterialListingCreation({super.key});

  @override
  State<MaterialListingCreation> createState() =>
      _MaterialListingCreationState();
}

class _MaterialListingCreationState extends State<MaterialListingCreation>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // Form controllers
  final TextEditingController _materialNameController = TextEditingController();
  final TextEditingController _scientificNameController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _minOrderController = TextEditingController();
  final TextEditingController _priceRangeController = TextEditingController();

  // Form state
  String? _selectedCategory;
  String? _selectedCountry;
  String? _selectedUnit;
  bool _isInStock = true;
  DateTime? _availabilityDate;
  List<String> _tradeNames = [];
  List<String> _uploadedImages = [];
  int _primaryImageIndex = 0;
  String? _technicalDataSheet;
  List<String> _certifications = [];
  bool _isFormValid = false;
  bool _isAutoSaving = false;

  // Mock data
  final List<String> _categories = [
    'Minerals',
    'Plastics',
    'Chemicals',
    'Metals',
    'Composites',
    'Ceramics'
  ];

  final List<String> _countries = [
    'United States',
    'China',
    'Germany',
    'India',
    'Japan',
    'United Kingdom',
    'Canada',
    'Australia'
  ];

  final List<String> _units = [
    'Kilograms (kg)',
    'Tons (t)',
    'Pounds (lbs)',
    'Grams (g)',
    'Liters (L)',
    'Cubic Meters (m³)'
  ];

  @override
  void initState() {
    super.initState();
    _setupAutoSave();
    _validateForm();
  }

  void _setupAutoSave() {
    _materialNameController.addListener(_onFormChanged);
    _scientificNameController.addListener(_onFormChanged);
    _descriptionController.addListener(_onFormChanged);
    _quantityController.addListener(_onFormChanged);
    _minOrderController.addListener(_onFormChanged);
    _priceRangeController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    _validateForm();
    _autoSaveDraft();
  }

  void _validateForm() {
    final isValid = _materialNameController.text.isNotEmpty &&
        _scientificNameController.text.isNotEmpty &&
        _selectedCategory != null &&
        _descriptionController.text.isNotEmpty &&
        _selectedCountry != null &&
        _quantityController.text.isNotEmpty &&
        _uploadedImages.isNotEmpty;

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void _autoSaveDraft() async {
    if (!_isAutoSaving) {
      setState(() {
        _isAutoSaving = true;
      });

      // Simulate auto-save delay
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isAutoSaving = false;
      });
    }
  }

  void _saveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Draft saved successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _previewListing() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening preview...'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      );
    }
  }

  void _publishListing() {
    if (_isFormValid && (_formKey.currentState?.validate() ?? false)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Publish Listing'),
          content:
              Text('Are you sure you want to publish this material listing?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Material listing published successfully!'),
                    backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                  ),
                );
                Navigator.pushReplacementNamed(context, '/supplier-dashboard');
              },
              child: Text('Publish'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _materialNameController.dispose();
    _scientificNameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _minOrderController.dispose();
    _priceRangeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialFormWidget(
                        materialNameController: _materialNameController,
                        scientificNameController: _scientificNameController,
                        descriptionController: _descriptionController,
                        selectedCategory: _selectedCategory,
                        categories: _categories,
                        tradeNames: _tradeNames,
                        onCategoryChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                        onTradeNamesChanged: (names) {
                          setState(() {
                            _tradeNames = names;
                          });
                        },
                      ),
                      SizedBox(height: 3.h),
                      ImageUploadWidget(
                        uploadedImages: _uploadedImages,
                        primaryImageIndex: _primaryImageIndex,
                        onImagesChanged: (images) {
                          setState(() {
                            _uploadedImages = images;
                          });
                        },
                        onPrimaryImageChanged: (index) {
                          setState(() {
                            _primaryImageIndex = index;
                          });
                        },
                      ),
                      SizedBox(height: 3.h),
                      TechnicalSpecsWidget(
                        selectedCountry: _selectedCountry,
                        countries: _countries,
                        quantityController: _quantityController,
                        minOrderController: _minOrderController,
                        priceRangeController: _priceRangeController,
                        selectedUnit: _selectedUnit,
                        units: _units,
                        technicalDataSheet: _technicalDataSheet,
                        onCountryChanged: (value) {
                          setState(() {
                            _selectedCountry = value;
                          });
                        },
                        onUnitChanged: (value) {
                          setState(() {
                            _selectedUnit = value;
                          });
                        },
                        onDataSheetUploaded: (fileName) {
                          setState(() {
                            _technicalDataSheet = fileName;
                          });
                        },
                      ),
                      SizedBox(height: 3.h),
                      AvailabilityWidget(
                        isInStock: _isInStock,
                        availabilityDate: _availabilityDate,
                        onStockStatusChanged: (value) {
                          setState(() {
                            _isInStock = value;
                          });
                        },
                        onDateChanged: (date) {
                          setState(() {
                            _availabilityDate = date;
                          });
                        },
                      ),
                      SizedBox(height: 3.h),
                      AdvancedOptionsWidget(
                        certifications: _certifications,
                        onCertificationsChanged: (certs) {
                          setState(() {
                            _certifications = certs;
                          });
                        },
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Create Material Listing'),
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        if (_isAutoSaving)
          Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        TextButton(
          onPressed: _saveDraft,
          child: Text('Save Draft'),
        ),
        TextButton(
          onPressed: _previewListing,
          child: Text('Preview'),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step 1 of 1',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              Text(
                _isFormValid ? 'Ready to publish' : 'Complete required fields',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: _isFormValid
                      ? AppTheme.lightTheme.colorScheme.secondary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: _isFormValid ? 1.0 : 0.6,
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              _isFormValid
                  ? AppTheme.lightTheme.colorScheme.secondary
                  : AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton(
            onPressed: _isFormValid ? _publishListing : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFormValid
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
              foregroundColor: _isFormValid
                  ? AppTheme.lightTheme.colorScheme.onPrimary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            child: Text(
              'Publish Listing',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: _isFormValid
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
