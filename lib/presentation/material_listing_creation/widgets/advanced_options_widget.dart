import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedOptionsWidget extends StatefulWidget {
  final List<String> certifications;
  final Function(List<String>) onCertificationsChanged;

  const AdvancedOptionsWidget({
    super.key,
    required this.certifications,
    required this.onCertificationsChanged,
  });

  @override
  State<AdvancedOptionsWidget> createState() => _AdvancedOptionsWidgetState();
}

class _AdvancedOptionsWidgetState extends State<AdvancedOptionsWidget> {
  final TextEditingController _storageController = TextEditingController();
  final TextEditingController _shippingController = TextEditingController();
  final TextEditingController _handlingController = TextEditingController();

  bool _isExpanded = false;
  bool _isUploadingCertification = false;

  final List<String> _sampleCertifications = [
    'ISO_9001_Certificate.pdf',
    'Quality_Assurance_Report.pdf',
    'Safety_Data_Sheet.pdf',
  ];

  @override
  void dispose() {
    _storageController.dispose();
    _shippingController.dispose();
    _handlingController.dispose();
    super.dispose();
  }

  void _uploadCertification() async {
    setState(() {
      _isUploadingCertification = true;
    });

    // Simulate upload delay
    await Future.delayed(const Duration(seconds: 2));

    final newCertifications = List<String>.from(widget.certifications);
    final randomCert = _sampleCertifications[
        newCertifications.length % _sampleCertifications.length];
    newCertifications.add(randomCert);

    widget.onCertificationsChanged(newCertifications);

    setState(() {
      _isUploadingCertification = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Certification uploaded successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _removeCertification(int index) {
    final newCertifications = List<String>.from(widget.certifications);
    newCertifications.removeAt(index);
    widget.onCertificationsChanged(newCertifications);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Advanced Options',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                  CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ],
              ),
            ),
            if (_isExpanded) ...[
              SizedBox(height: 2.h),
              _buildCertificationsSection(),
              SizedBox(height: 2.h),
              _buildStorageRequirements(),
              SizedBox(height: 2.h),
              _buildShippingInformation(),
              SizedBox(height: 2.h),
              _buildSpecialHandlingNotes(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCertificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Certifications',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Upload quality certificates, safety data sheets, and compliance documents',
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
        SizedBox(height: 1.h),
        if (widget.certifications.isNotEmpty) ...[
          ...widget.certifications.asMap().entries.map((entry) {
            final index = entry.key;
            final certification = entry.value;
            return Container(
              margin: EdgeInsets.only(bottom: 1.h),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                border:
                    Border.all(color: AppTheme.lightTheme.colorScheme.outline),
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
                      iconName: 'verified',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          certification,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                        Text(
                          '1.2 MB • PDF',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _removeCertification(index),
                    icon: CustomIconWidget(
                      iconName: 'delete',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 20,
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 1.h),
        ],
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed:
                _isUploadingCertification || widget.certifications.length >= 5
                    ? null
                    : _uploadCertification,
            icon: _isUploadingCertification
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : CustomIconWidget(
                    iconName: 'upload_file',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
            label: Text(_isUploadingCertification
                ? 'Uploading...'
                : 'Add Certification'),
          ),
        ),
      ],
    );
  }

  Widget _buildStorageRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Storage Requirements',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 0.5.h),
        TextFormField(
          controller: _storageController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText:
                'Describe storage conditions (temperature, humidity, special requirements)...',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'warehouse',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }

  Widget _buildShippingInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping Information',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 0.5.h),
        TextFormField(
          controller: _shippingController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText:
                'Shipping methods, packaging details, delivery timeframes...',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'local_shipping',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialHandlingNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Special Handling Notes',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 0.5.h),
        TextFormField(
          controller: _handlingController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText:
                'Safety precautions, handling instructions, hazard warnings...',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'warning',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }
}
