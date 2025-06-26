import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DocumentUploadSection extends StatefulWidget {
  final List<String> uploadedDocuments;
  final Function(List<String>) onDocumentUploaded;

  const DocumentUploadSection({
    super.key,
    required this.uploadedDocuments,
    required this.onDocumentUploaded,
  });

  @override
  State<DocumentUploadSection> createState() => _DocumentUploadSectionState();
}

class _DocumentUploadSectionState extends State<DocumentUploadSection> {
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  final List<Map<String, dynamic>> _requiredDocuments = [
    {
      'id': 'business_license',
      'name': 'Business License',
      'description': 'Valid business registration certificate',
      'required': true,
      'uploaded': false,
    },
    {
      'id': 'tax_certificate',
      'name': 'Tax Certificate',
      'description': 'Tax registration or VAT certificate',
      'required': true,
      'uploaded': false,
    },
    {
      'id': 'quality_certificates',
      'name': 'Quality Certificates',
      'description': 'ISO certifications, quality standards',
      'required': false,
      'uploaded': false,
    },
    {
      'id': 'insurance_certificate',
      'name': 'Insurance Certificate',
      'description': 'Business liability insurance',
      'required': false,
      'uploaded': false,
    },
  ];

  Future<void> _uploadDocument(String documentId) async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    // Mock upload process with progress
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _uploadProgress = i / 100;
      });
    }

    // Update document status
    final documentIndex =
        _requiredDocuments.indexWhere((doc) => doc['id'] == documentId);
    if (documentIndex != -1) {
      setState(() {
        _requiredDocuments[documentIndex]['uploaded'] = true;
        _isUploading = false;
      });

      // Update uploaded documents list
      List<String> updatedDocuments = List.from(widget.uploadedDocuments);
      if (!updatedDocuments.contains(documentId)) {
        updatedDocuments.add(documentId);
      }
      widget.onDocumentUploaded(updatedDocuments);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Document uploaded successfully'),
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        ),
      );
    }
  }

  void _removeDocument(String documentId) {
    final documentIndex =
        _requiredDocuments.indexWhere((doc) => doc['id'] == documentId);
    if (documentIndex != -1) {
      setState(() {
        _requiredDocuments[documentIndex]['uploaded'] = false;
      });

      List<String> updatedDocuments = List.from(widget.uploadedDocuments);
      updatedDocuments.remove(documentId);
      widget.onDocumentUploaded(updatedDocuments);
    }
  }

  @override
  Widget build(BuildContext context) {
    final requiredUploaded = _requiredDocuments
        .where((doc) => doc['required'] == true && doc['uploaded'] == true)
        .length;
    final totalRequired =
        _requiredDocuments.where((doc) => doc['required'] == true).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Document Upload',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        SizedBox(height: 1.h),
        Text(
          'Upload required business documents for verification',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),

        // Upload Progress Summary
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: requiredUploaded == totalRequired
                ? AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: requiredUploaded == totalRequired
                  ? AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.2)
                  : AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: requiredUploaded == totalRequired
                    ? 'check_circle'
                    : 'upload_file',
                color: requiredUploaded == totalRequired
                    ? AppTheme.lightTheme.colorScheme.secondary
                    : AppTheme.lightTheme.colorScheme.tertiary,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$requiredUploaded of $totalRequired required documents uploaded',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: requiredUploaded == totalRequired
                            ? AppTheme.lightTheme.colorScheme.secondary
                            : AppTheme.lightTheme.colorScheme.tertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (requiredUploaded < totalRequired)
                      Text(
                        'Complete required uploads to proceed',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Upload Progress Indicator
        if (_isUploading)
          Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Uploading...',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    Text(
                      '${(_uploadProgress * 100).round()}%',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                LinearProgressIndicator(
                  value: _uploadProgress,
                  backgroundColor: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

        // Document List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _requiredDocuments.length,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            final document = _requiredDocuments[index];
            final isUploaded = document['uploaded'] == true;
            final isRequired = document['required'] == true;

            return Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                border: Border.all(
                  color: isUploaded
                      ? AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.3)
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // Document Icon
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: isUploaded
                          ? AppTheme.lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: isUploaded ? 'check_circle' : 'description',
                      color: isUploaded
                          ? AppTheme.lightTheme.colorScheme.secondary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),

                  SizedBox(width: 3.w),

                  // Document Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              document['name'],
                              style: AppTheme.lightTheme.textTheme.titleMedium,
                            ),
                            if (isRequired) ...[
                              SizedBox(width: 1.w),
                              Text(
                                '*',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme.error,
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          document['description'],
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (isUploaded) ...[
                          SizedBox(height: 1.h),
                          Text(
                            'Uploaded successfully',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(width: 2.w),

                  // Action Button
                  isUploaded
                      ? IconButton(
                          onPressed: () => _removeDocument(document['id']),
                          icon: CustomIconWidget(
                            iconName: 'delete',
                            color: AppTheme.lightTheme.colorScheme.error,
                            size: 20,
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _isUploading
                              ? null
                              : () => _uploadDocument(document['id']),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                          ),
                          child: Text('Upload'),
                        ),
                ],
              ),
            );
          },
        ),

        SizedBox(height: 2.h),

        // Upload Guidelines
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Upload Guidelines',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                '• Supported formats: PDF, JPG, PNG (max 10MB each)\n'
                '• Documents must be clear and legible\n'
                '• All information must be current and valid\n'
                '• Processing time: 1-2 business days',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
