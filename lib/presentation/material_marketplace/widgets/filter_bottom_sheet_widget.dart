import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';


class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onApplyFilters;
  final VoidCallback onClearFilters;

  const FilterBottomSheetWidget({
    super.key,
    required this.currentFilters,
    required this.onApplyFilters,
    required this.onClearFilters,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  Map<String, dynamic> _filters = {};
  RangeValues _priceRange = const RangeValues(0, 10000);
  double _locationRadius = 50.0;

  final List<String> _categories = [
    'Metals',
    'Plastics',
    'Chemicals',
    'Ceramics',
    'Composites',
    'Textiles',
    'Rubber',
    'Glass',
  ];

  final List<String> _availabilityOptions = [
    'Available',
    'Out of Stock',
    'Pre-order',
  ];

  final List<String> _certificationOptions = [
    'ISO 9001',
    'ISO 14001',
    'CE Marking',
    'FDA Approved',
    'RoHS Compliant',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
    _priceRange = RangeValues(
      _filters['minPrice']?.toDouble() ?? 0,
      _filters['maxPrice']?.toDouble() ?? 10000,
    );
    _locationRadius = _filters['locationRadius']?.toDouble() ?? 50.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(102),
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Materials',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filters.clear();
                      _priceRange = const RangeValues(0, 10000);
                      _locationRadius = 50.0;
                    });
                    widget.onClearFilters();
                  },
                  child: Text(
                    'Clear All',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.outline.withAlpha(51),
          ),
          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories
                  _buildSectionTitle('Categories'),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _categories.map((category) {
                      final isSelected =
                          _filters['categories']?.contains(category) ?? false;
                      return FilterChip(
                        label: Text(
                          category,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _filters['categories'] ??= <String>[];
                            if (selected) {
                              _filters['categories'].add(category);
                            } else {
                              _filters['categories'].remove(category);
                            }
                          });
                        },
                        selectedColor: Theme.of(context).colorScheme.primary,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceContainerHighest,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),

                  // Price Range
                  _buildSectionTitle(
                      'Price Range (\$${_priceRange.start.round()} - \$${_priceRange.end.round()})'),
                  SizedBox(height: 8.h),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 10000,
                    divisions: 100,
                    labels: RangeLabels(
                      '\$${_priceRange.start.round()}',
                      '\$${_priceRange.end.round()}',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                        _filters['minPrice'] = values.start;
                        _filters['maxPrice'] = values.end;
                      });
                    },
                  ),
                  SizedBox(height: 20.h),

                  // Location Radius
                  _buildSectionTitle(
                      'Location Radius (${_locationRadius.round()} km)'),
                  SizedBox(height: 8.h),
                  Slider(
                    value: _locationRadius,
                    min: 10,
                    max: 500,
                    divisions: 49,
                    label: '${_locationRadius.round()} km',
                    onChanged: (value) {
                      setState(() {
                        _locationRadius = value;
                        _filters['locationRadius'] = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.h),

                  // Availability Status
                  _buildSectionTitle('Availability Status'),
                  SizedBox(height: 8.h),
                  Column(
                    children: _availabilityOptions.map((option) {
                      final isSelected = _filters['availability'] == option;
                      return RadioListTile<String>(
                        title: Text(
                          option,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        value: option,
                        groupValue: _filters['availability'],
                        onChanged: (value) {
                          setState(() {
                            _filters['availability'] = value;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),

                  // Certifications
                  _buildSectionTitle('Certifications'),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _certificationOptions.map((certification) {
                      final isSelected =
                          _filters['certifications']?.contains(certification) ??
                              false;
                      return FilterChip(
                        label: Text(
                          certification,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _filters['certifications'] ??= <String>[];
                            if (selected) {
                              _filters['certifications'].add(certification);
                            } else {
                              _filters['certifications'].remove(certification);
                            }
                          });
                        },
                        selectedColor: Theme.of(context).colorScheme.primary,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceContainerHighest,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 80.h), // Extra space for apply button
                ],
              ),
            ),
          ),
          // Apply button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withAlpha(51),
                ),
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                widget.onApplyFilters(_filters);
                Navigator.pop(context);
              },
              child: Text(
                'Apply Filters',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
