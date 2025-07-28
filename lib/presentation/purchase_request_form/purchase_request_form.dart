import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import './widgets/additional_requirements_widget.dart';
import './widgets/delivery_information_widget.dart';
import './widgets/draft_save_widget.dart';
import './widgets/form_progress_widget.dart';
import './widgets/material_selection_widget.dart';
import './widgets/payment_terms_widget.dart';
import './widgets/quantity_specification_widget.dart';
import './widgets/specifications_widget.dart';

class PurchaseRequestForm extends StatefulWidget {
  const PurchaseRequestForm({super.key});

  @override
  State<PurchaseRequestForm> createState() => _PurchaseRequestFormState();
}

class _PurchaseRequestFormState extends State<PurchaseRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form controllers
  final _materialController = TextEditingController();
  final _quantityController = TextEditingController();
  final _targetPriceController = TextEditingController();
  final _specificationsController = TextEditingController();
  final _addressController = TextEditingController();
  final _specialInstructionsController = TextEditingController();
  final _additionalRequirementsController = TextEditingController();
  final _customPaymentTermsController = TextEditingController();

  // Form state
  Map<String, dynamic>? _selectedMaterial;
  String _selectedUnit = 'kg';
  RangeValues _priceRange = const RangeValues(0, 1000);
  DateTime? _requiredDate;
  DateTime? _preferredDate;
  String _urgency = 'Standard';
  String _shippingMethod = 'Standard';
  String _paymentTerms = 'Net 30';
  final List<String> _attachments = [];
  final List<String> _certifications = [];
  final List<String> _packagingSpecs = [];
  final bool _isAutoSaveEnabled = true;
  bool _isSubmitting = false;
  String? _draftId;

  // Progress tracking
  double _completionProgress = 0.0;
  final Map<String, bool> _sectionCompletion = {
    'material': false,
    'quantity': false,
    'delivery': false,
    'specifications': false,
    'payment': false,
  };

  @override
  void initState() {
    super.initState();
    _loadDraftData();
    _setupAutoSave();
    _calculateProgress();
  }

  @override
  void dispose() {
    _materialController.dispose();
    _quantityController.dispose();
    _targetPriceController.dispose();
    _specificationsController.dispose();
    _addressController.dispose();
    _specialInstructionsController.dispose();
    _additionalRequirementsController.dispose();
    _customPaymentTermsController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadDraftData() {
    // Load draft data from arguments if available
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      setState(() {
        _selectedMaterial = arguments['material'];
        _materialController.text = _selectedMaterial?['materialName'] ?? '';
        _calculateProgress();
      });
    }
  }

  void _setupAutoSave() {
    // Auto-save every 30 seconds
    if (_isAutoSaveEnabled) {
      Future.delayed(const Duration(seconds: 30), () {
        if (mounted) {
          _saveDraft();
          _setupAutoSave();
        }
      });
    }
  }

  void _calculateProgress() {
    _sectionCompletion['material'] = _selectedMaterial != null;
    _sectionCompletion['quantity'] = _quantityController.text.isNotEmpty;
    _sectionCompletion['delivery'] =
        _requiredDate != null && _addressController.text.isNotEmpty;
    _sectionCompletion['specifications'] =
        _specificationsController.text.isNotEmpty;
    _sectionCompletion['payment'] = _paymentTerms.isNotEmpty;

    final completedSections =
        _sectionCompletion.values.where((completed) => completed).length;
    setState(() {
      _completionProgress = completedSections / _sectionCompletion.length;
    });
  }

  void _saveDraft() {
    if (_formKey.currentState?.validate() ?? false) {
      // Save draft logic
      _draftId = DateTime.now().millisecondsSinceEpoch.toString();
      Fluttertoast.showToast(
        msg: "Draft saved",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> _submitRequest() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Success
      Fluttertoast.showToast(
        msg: "Purchase request submitted successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );

      // Navigate back
      Navigator.pop(context);
    } catch (e) {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit request: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  bool _isFormValid() {
    return _selectedMaterial != null &&
        _quantityController.text.isNotEmpty &&
        _requiredDate != null &&
        _addressController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(
                'Purchase Request',
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              pinned: true,
              floating: true,
              actions: [
                DraftSaveWidget(
                  onSaveDraft: _saveDraft,
                  hasUnsavedChanges: _draftId == null,
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(60.h),
                child: FormProgressWidget(
                  progress: _completionProgress,
                  sectionCompletion: _sectionCompletion,
                ),
              ),
            ),
          ];
        },
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              // Material Selection
              MaterialSelectionWidget(
                controller: _materialController,
                selectedMaterial: _selectedMaterial,
                onMaterialSelected: (material) {
                  setState(() {
                    _selectedMaterial = material;
                    _materialController.text = material['materialName'] ?? '';
                    _calculateProgress();
                  });
                },
              ),
              SizedBox(height: 16.h),

              // Quantity Specification
              QuantitySpecificationWidget(
                quantityController: _quantityController,
                selectedUnit: _selectedUnit,
                priceRange: _priceRange,
                onUnitChanged: (unit) {
                  setState(() {
                    _selectedUnit = unit;
                    _calculateProgress();
                  });
                },
                onPriceRangeChanged: (range) {
                  setState(() {
                    _priceRange = range;
                  });
                },
              ),
              SizedBox(height: 16.h),

              // Delivery Information
              DeliveryInformationWidget(
                addressController: _addressController,
                specialInstructionsController: _specialInstructionsController,
                requiredDate: _requiredDate,
                preferredDate: _preferredDate,
                urgency: _urgency,
                shippingMethod: _shippingMethod,
                onRequiredDateChanged: (date) {
                  setState(() {
                    _requiredDate = date;
                    _calculateProgress();
                  });
                },
                onPreferredDateChanged: (date) {
                  setState(() {
                    _preferredDate = date;
                  });
                },
                onUrgencyChanged: (urgency) {
                  setState(() {
                    _urgency = urgency;
                  });
                },
                onShippingMethodChanged: (method) {
                  setState(() {
                    _shippingMethod = method;
                  });
                },
              ),
              SizedBox(height: 16.h),

              // Specifications
              SpecificationsWidget(
                controller: _specificationsController,
                attachments: _attachments,
                onAttachmentAdded: (attachment) {
                  setState(() {
                    _attachments.add(attachment);
                    _calculateProgress();
                  });
                },
                onAttachmentRemoved: (attachment) {
                  setState(() {
                    _attachments.remove(attachment);
                  });
                },
              ),
              SizedBox(height: 16.h),

              // Payment Terms
              PaymentTermsWidget(
                selectedPaymentTerms: _paymentTerms,
                customTermsController: _customPaymentTermsController,
                onPaymentTermsChanged: (terms) {
                  setState(() {
                    _paymentTerms = terms;
                    _calculateProgress();
                  });
                },
              ),
              SizedBox(height: 16.h),

              // Additional Requirements
              AdditionalRequirementsWidget(
                controller: _additionalRequirementsController,
                certifications: _certifications,
                packagingSpecs: _packagingSpecs,
                onCertificationAdded: (cert) {
                  setState(() {
                    _certifications.add(cert);
                  });
                },
                onCertificationRemoved: (cert) {
                  setState(() {
                    _certifications.remove(cert);
                  });
                },
                onPackagingSpecAdded: (spec) {
                  setState(() {
                    _packagingSpecs.add(spec);
                  });
                },
                onPackagingSpecRemoved: (spec) {
                  setState(() {
                    _packagingSpecs.remove(spec);
                  });
                },
              ),
              SizedBox(height: 100.h), // Space for bottom button
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _isFormValid() && !_isSubmitting ? _submitRequest : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: _isSubmitting
                  ? SizedBox(
                      height: 20.h,
                      width: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      'Send Request',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
