import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SpecificationsWidget extends StatelessWidget {
  final TextEditingController controller;
  final List<String> attachments;
  final Function(String) onAttachmentAdded;
  final Function(String) onAttachmentRemoved;

  const SpecificationsWidget({
    super.key,
    required this.controller,
    required this.attachments,
    required this.onAttachmentAdded,
    required this.onAttachmentRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.description,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Detailed Specifications',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Specifications text field
            TextFormField(
              controller: controller,
              maxLines: 5,
              maxLength: 1000,
              decoration: const InputDecoration(
                labelText: 'Custom Requirements & Specifications',
                hintText:
                    'Describe your specific requirements, quality standards, or any special considerations...',
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide specifications';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Attachments section
            Row(
              children: [
                Icon(
                  Icons.attach_file,
                  size: 16.sp,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Attachments',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _showAttachmentOptions(context),
                  icon: Icon(
                    Icons.add,
                    size: 16.sp,
                  ),
                  label: Text(
                    'Add',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // Attachment types info
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Supported file types:',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 4.h,
                    children: [
                      _buildFileTypeChip(context, 'PDF', Icons.picture_as_pdf),
                      _buildFileTypeChip(context, 'DOC', Icons.description),
                      _buildFileTypeChip(context, 'Images', Icons.image),
                      _buildFileTypeChip(context, 'CAD', Icons.architecture),
                    ],
                  ),
                ],
              ),
            ),

            // Attachment list
            if (attachments.isNotEmpty) ...[
              SizedBox(height: 16.h),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: attachments.length,
                itemBuilder: (context, index) {
                  final attachment = attachments[index];
                  return _buildAttachmentItem(context, attachment);
                },
              ),
            ],

            SizedBox(height: 16.h),

            // Upload guidelines
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16.sp,
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Upload Guidelines',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '• Maximum file size: 10MB\n'
                    '• Technical drawings help suppliers understand requirements\n'
                    '• Quality samples can be shared as photos\n'
                    '• Specifications sheets ensure accurate quotes',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileTypeChip(BuildContext context, String type, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          SizedBox(width: 4.w),
          Text(
            type,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentItem(BuildContext context, String attachment) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getFileIcon(attachment),
            size: 20.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Uploaded successfully',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => onAttachmentRemoved(attachment),
            icon: Icon(
              Icons.close,
              size: 20.sp,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Attachment',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'Take Photo',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _mockUpload(
                      'photo_${DateTime.now().millisecondsSinceEpoch}.jpg');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'Choose from Gallery',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _mockUpload(
                      'image_${DateTime.now().millisecondsSinceEpoch}.jpg');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.file_present,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'Upload Document',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _mockUpload(
                      'document_${DateTime.now().millisecondsSinceEpoch}.pdf');
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  void _mockUpload(String filename) {
    // Simulate file upload
    Future.delayed(const Duration(seconds: 1), () {
      onAttachmentAdded(filename);
      Fluttertoast.showToast(
        msg: 'File uploaded successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    });
  }

  IconData _getFileIcon(String filename) {
    final extension = filename.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'dwg':
      case 'dxf':
        return Icons.architecture;
      default:
        return Icons.insert_drive_file;
    }
  }
}
