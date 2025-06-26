import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TechnicalSpecsWidget extends StatefulWidget {
  final String? selectedCountry;
  final List<String> countries;
  final TextEditingController quantityController;
  final TextEditingController minOrderController;
  final TextEditingController priceRangeController;
  final String? selectedUnit;
  final List<String> units;
  final String? technicalDataSheet;
  final Function(String?) onCountryChanged;
  final Function(String?) onUnitChanged;
  final Function(String) onDataSheetUploaded;

  const TechnicalSpecsWidget({
    super.key,
    required this.selectedCountry,
    required this.countries,
    required this.quantityController,
    required this.minOrderController,
    required this.priceRangeController,
    required this.selectedUnit,
    required this.units,
    required this.technicalDataSheet,
    required this.onCountryChanged,
    required this.onUnitChanged,
    required this.onDataSheetUploaded,
  });

  @override
  State<TechnicalSpecsWidget> createState() => _TechnicalSpecsWidgetState();
}

class _TechnicalSpecsWidgetState extends State<TechnicalSpecsWidget> {
  bool _isUploadingDataSheet = false;
  double _uploadProgress = 0.0;

  void _uploadDataSheet() async {
    setState(() {
      _isUploadingDataSheet = true;
      _uploadProgress = 0.0;
    });

    // Simulate file upload with progress
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _uploadProgress = i / 100;
      });
    }

    setState(() {
      _isUploadingDataSheet = false;
    });

    widget.onDataSheetUploaded('technical_datasheet.pdf');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Technical data sheet uploaded successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _removeDataSheet() {
    widget.onDataSheetUploaded('');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Technical Specifications',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            _buildCountryField(),
            SizedBox(height: 2.h),
            _buildQuantityFields(),
            SizedBox(height: 2.h),
            _buildPriceRangeField(),
            SizedBox(height: 2.h),
            _buildDataSheetSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Country of Origin *',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 0.5.h),
        DropdownButtonFormField<String>(
          value: widget.selectedCountry,
          decoration: InputDecoration(
            hintText: 'Select country',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'public',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          items: widget.countries.map((country) {
            return DropdownMenuItem(
              value: country,
              child: Text(country),
            );
          }).toList(),
          onChanged: widget.onCountryChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Country of origin is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildQuantityFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity Information *',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: widget.quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Available Quantity',
                  hintText: '1000',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'inventory',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Quantity is required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Enter valid number';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                value: widget.selectedUnit,
                decoration: InputDecoration(
                  labelText: 'Unit',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.w),
                ),
                items: widget.units.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(
                      unit.split(' ')[0], // Show only the unit abbreviation
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: widget.onUnitChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unit required';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: widget.minOrderController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Minimum Order Quantity',
            hintText: '100',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'shopping_cart',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (double.tryParse(value) == null) {
                return 'Enter valid number';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPriceRangeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 0.5.h),
        TextFormField(
          controller: widget.priceRangeController,
          decoration: InputDecoration(
            hintText: 'e.g., \$50 - \$100 per kg',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'attach_money',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataSheetSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Technical Data Sheet',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Upload PDF file with technical specifications (Max 10MB)',
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
        SizedBox(height: 1.h),
        if (widget.technicalDataSheet == null ||
            widget.technicalDataSheet!.isEmpty)
          _buildUploadButton()
        else
          _buildUploadedFileCard(),
        if (_isUploadingDataSheet) ...[
          SizedBox(height: 1.h),
          _buildUploadProgress(),
        ],
      ],
    );
  }

  Widget _buildUploadButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _isUploadingDataSheet ? null : _uploadDataSheet,
        icon: CustomIconWidget(
          iconName: 'upload_file',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 20,
        ),
        label: Text('Upload PDF'),
      ),
    );
  }

  Widget _buildUploadedFileCard() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.lightTheme.colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: CustomIconWidget(
              iconName: 'picture_as_pdf',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.technicalDataSheet!,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                Text(
                  '2.4 MB • PDF',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _removeDataSheet,
            icon: CustomIconWidget(
              iconName: 'delete',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadProgress() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Uploading...',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            Text(
              '${(_uploadProgress * 100).toInt()}%',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        LinearProgressIndicator(
          value: _uploadProgress,
          backgroundColor:
              AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          valueColor: AlwaysStoppedAnimation<Color>(
            AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
