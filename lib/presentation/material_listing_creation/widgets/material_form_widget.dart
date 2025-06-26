import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MaterialFormWidget extends StatefulWidget {
  final TextEditingController materialNameController;
  final TextEditingController scientificNameController;
  final TextEditingController descriptionController;
  final String? selectedCategory;
  final List<String> categories;
  final List<String> tradeNames;
  final Function(String?) onCategoryChanged;
  final Function(List<String>) onTradeNamesChanged;

  const MaterialFormWidget({
    super.key,
    required this.materialNameController,
    required this.scientificNameController,
    required this.descriptionController,
    required this.selectedCategory,
    required this.categories,
    required this.tradeNames,
    required this.onCategoryChanged,
    required this.onTradeNamesChanged,
  });

  @override
  State<MaterialFormWidget> createState() => _MaterialFormWidgetState();
}

class _MaterialFormWidgetState extends State<MaterialFormWidget> {
  final TextEditingController _tradeNameController = TextEditingController();
  final int _maxDescriptionLength = 500;

  final List<String> _materialSuggestions = [
    'Aluminum Oxide',
    'Polyethylene',
    'Steel Alloy',
    'Copper Wire',
    'Silicon Carbide',
    'Titanium Dioxide',
    'Carbon Fiber',
    'Stainless Steel'
  ];

  @override
  void dispose() {
    _tradeNameController.dispose();
    super.dispose();
  }

  void _addTradeName() {
    if (_tradeNameController.text.trim().isNotEmpty) {
      final newTradeNames = List<String>.from(widget.tradeNames);
      newTradeNames.add(_tradeNameController.text.trim());
      widget.onTradeNamesChanged(newTradeNames);
      _tradeNameController.clear();
    }
  }

  void _removeTradeName(int index) {
    final newTradeNames = List<String>.from(widget.tradeNames);
    newTradeNames.removeAt(index);
    widget.onTradeNamesChanged(newTradeNames);
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
              'Material Information',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            _buildMaterialNameField(),
            SizedBox(height: 2.h),
            _buildScientificNameField(),
            SizedBox(height: 2.h),
            _buildTradeNamesSection(),
            SizedBox(height: 2.h),
            _buildCategoryField(),
            SizedBox(height: 2.h),
            _buildDescriptionField(),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Material Name *',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 0.5.h),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return _materialSuggestions.where((String option) {
              return option
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            });
          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            widget.materialNameController.text = controller.text;
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Enter material name',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'inventory_2',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Material name is required';
                }
                return null;
              },
              onChanged: (value) {
                widget.materialNameController.text = value;
              },
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 30.h,
                    maxWidth: 80.w,
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        title: Text(option),
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildScientificNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scientific Name *',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 0.5.h),
        TextFormField(
          controller: widget.scientificNameController,
          decoration: InputDecoration(
            hintText: 'Enter scientific name',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'science',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Scientific name is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTradeNamesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trade Names',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 0.5.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _tradeNameController,
                decoration: InputDecoration(
                  hintText: 'Add trade name',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'local_offer',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
                onFieldSubmitted: (_) => _addTradeName(),
              ),
            ),
            SizedBox(width: 2.w),
            IconButton(
              onPressed: _addTradeName,
              icon: CustomIconWidget(
                iconName: 'add_circle',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
          ],
        ),
        if (widget.tradeNames.isNotEmpty) ...[
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: widget.tradeNames.asMap().entries.map((entry) {
              final index = entry.key;
              final tradeName = entry.value;
              return Chip(
                label: Text(tradeName),
                deleteIcon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                onDeleted: () => _removeTradeName(index),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category *',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 0.5.h),
        DropdownButtonFormField<String>(
          value: widget.selectedCategory,
          decoration: InputDecoration(
            hintText: 'Select category',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'category',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          items: widget.categories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: widget.onCategoryChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Category is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description *',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 0.5.h),
        TextFormField(
          controller: widget.descriptionController,
          maxLines: 4,
          maxLength: _maxDescriptionLength,
          decoration: InputDecoration(
            hintText:
                'Describe the material properties, applications, and specifications...',
            alignLabelWithHint: true,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Description is required';
            }
            if (value.length < 50) {
              return 'Description must be at least 50 characters';
            }
            return null;
          },
        ),
      ],
    );
  }
}
