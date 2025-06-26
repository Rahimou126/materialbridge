import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ImageUploadWidget extends StatefulWidget {
  final List<String> uploadedImages;
  final int primaryImageIndex;
  final Function(List<String>) onImagesChanged;
  final Function(int) onPrimaryImageChanged;

  const ImageUploadWidget({
    super.key,
    required this.uploadedImages,
    required this.primaryImageIndex,
    required this.onImagesChanged,
    required this.onPrimaryImageChanged,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  bool _isUploading = false;

  final List<String> _sampleImages = [
    'https://images.unsplash.com/photo-1581092160562-40aa08e78837?w=400',
    'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=400',
    'https://images.unsplash.com/photo-1581092160562-40aa08e78837?w=400',
  ];

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Image',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _simulateImageUpload('camera');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _simulateImageUpload('gallery');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _simulateImageUpload(String source) async {
    setState(() {
      _isUploading = true;
    });

    // Simulate upload delay
    await Future.delayed(const Duration(seconds: 2));

    final newImages = List<String>.from(widget.uploadedImages);
    final randomImage = _sampleImages[newImages.length % _sampleImages.length];
    newImages.add(randomImage);

    widget.onImagesChanged(newImages);

    setState(() {
      _isUploading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Image uploaded successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _removeImage(int index) {
    final newImages = List<String>.from(widget.uploadedImages);
    newImages.removeAt(index);
    widget.onImagesChanged(newImages);

    // Adjust primary image index if necessary
    if (widget.primaryImageIndex >= newImages.length && newImages.isNotEmpty) {
      widget.onPrimaryImageChanged(0);
    } else if (widget.primaryImageIndex == index && newImages.isNotEmpty) {
      widget.onPrimaryImageChanged(0);
    }
  }

  void _reorderImages(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final newImages = List<String>.from(widget.uploadedImages);
    final item = newImages.removeAt(oldIndex);
    newImages.insert(newIndex, item);

    widget.onImagesChanged(newImages);

    // Update primary image index
    if (widget.primaryImageIndex == oldIndex) {
      widget.onPrimaryImageChanged(newIndex);
    } else if (oldIndex < widget.primaryImageIndex &&
        newIndex >= widget.primaryImageIndex) {
      widget.onPrimaryImageChanged(widget.primaryImageIndex - 1);
    } else if (oldIndex > widget.primaryImageIndex &&
        newIndex <= widget.primaryImageIndex) {
      widget.onPrimaryImageChanged(widget.primaryImageIndex + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Material Images *',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                Text(
                  '${widget.uploadedImages.length}/10',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Upload high-quality images of your material. First image will be used as primary.',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            SizedBox(height: 2.h),
            _buildImageGrid(),
            SizedBox(height: 2.h),
            _buildUploadButton(),
            if (widget.uploadedImages.isNotEmpty) ...[
              SizedBox(height: 2.h),
              _buildPrimaryImageSelector(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    if (widget.uploadedImages.isEmpty) {
      return _buildEmptyState();
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.uploadedImages.length,
      onReorder: _reorderImages,
      itemBuilder: (context, index) {
        final imageUrl = widget.uploadedImages[index];
        final isPrimary = index == widget.primaryImageIndex;

        return Container(
          key: ValueKey(imageUrl),
          margin: EdgeInsets.only(bottom: 2.h),
          child: Stack(
            children: [
              Container(
                height: 20.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: isPrimary
                      ? Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          width: 2,
                        )
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: 20.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (isPrimary)
                Positioned(
                  top: 1.h,
                  left: 2.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'PRIMARY',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 1.h,
                right: 2.w,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => _removeImage(index),
                      icon: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'close',
                          color: AppTheme.lightTheme.colorScheme.onError,
                          size: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface
                              .withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'drag_handle',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 25.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'add_photo_alternate',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No images uploaded',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Text(
            'Add images to showcase your material',
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _isUploading || widget.uploadedImages.length >= 10
            ? null
            : _showImageSourceDialog,
        icon: _isUploading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : CustomIconWidget(
                iconName: 'add_a_photo',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
        label: Text(_isUploading ? 'Uploading...' : 'Add Images'),
      ),
    );
  }

  Widget _buildPrimaryImageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Primary Image',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 1.h),
        Text(
          'Select which image will be displayed as the main image',
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 12.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.uploadedImages.length,
            itemBuilder: (context, index) {
              final isSelected = index == widget.primaryImageIndex;
              return GestureDetector(
                onTap: () => widget.onPrimaryImageChanged(index),
                child: Container(
                  width: 20.w,
                  margin: EdgeInsets.only(right: 2.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CustomImageWidget(
                          imageUrl: widget.uploadedImages[index],
                          width: 20.w,
                          height: 12.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          top: 1.w,
                          right: 1.w,
                          child: Container(
                            padding: EdgeInsets.all(0.5.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: CustomIconWidget(
                              iconName: 'check',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
