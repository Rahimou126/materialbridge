import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestsFilterWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onApplyFilters;
  final VoidCallback onClearFilters;

  const RequestsFilterWidget({
    super.key,
    required this.currentFilters,
    required this.onApplyFilters,
    required this.onClearFilters,
  });

  @override
  State<RequestsFilterWidget> createState() => _RequestsFilterWidgetState();
}

class _RequestsFilterWidgetState extends State<RequestsFilterWidget> {
  late Map<String, dynamic> _filters;
  RangeValues _dateRange = RangeValues(0, 365);
  List<String> _selectedCategories = [];
  List<String> _selectedPriorities = [];
  String _selectedCustomer = '';

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
    _initializeFilters();
  }

  void _initializeFilters() {
    _selectedCategories = List<String>.from(_filters['categories'] ?? []);
    _selectedPriorities = List<String>.from(_filters['priorities'] ?? []);
    _selectedCustomer = _filters['customer'] ?? '';
  }

  void _applyFilters() {
    final filters = <String, dynamic>{};

    if (_selectedCategories.isNotEmpty) {
      filters['categories'] = _selectedCategories;
    }
    if (_selectedPriorities.isNotEmpty) {
      filters['priorities'] = _selectedPriorities;
    }
    if (_selectedCustomer.isNotEmpty) {
      filters['customer'] = _selectedCustomer;
    }

    widget.onApplyFilters(filters);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _filters.clear();
      _selectedCategories.clear();
      _selectedPriorities.clear();
      _selectedCustomer = '';
      _dateRange = RangeValues(0, 365);
    });
    widget.onClearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 8.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Requests',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: _clearFilters,
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

          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date range filter
                  _buildDateRangeFilter(),
                  SizedBox(height: 24.h),

                  // Material categories filter
                  _buildCategoriesFilter(),
                  SizedBox(height: 24.h),

                  // Priority filter
                  _buildPriorityFilter(),
                  SizedBox(height: 24.h),

                  // Customer filter
                  _buildCustomerFilter(),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text(
                      'Apply Filters',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 12.h),
        RangeSlider(
          values: _dateRange,
          min: 0,
          max: 365,
          divisions: 12,
          labels: RangeLabels(
            '${_dateRange.start.round()} days ago',
            '${_dateRange.end.round()} days ago',
          ),
          onChanged: (values) {
            setState(() {
              _dateRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Last ${_dateRange.start.round()} days',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              'Last ${_dateRange.end.round()} days',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoriesFilter() {
    final categories = [
      'Metals',
      'Plastics',
      'Chemicals',
      'Composites',
      'Glass',
      'Rubber'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Material Categories',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: categories.map((category) {
            final isSelected = _selectedCategories.contains(category);
            return FilterChip(
              label: Text(
                category,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: Theme.of(context).colorScheme.primary,
              checkmarkColor: Theme.of(context).colorScheme.onPrimary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriorityFilter() {
    final priorities = ['Standard', 'High', 'Urgent'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority Level',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: priorities.map((priority) {
            final isSelected = _selectedPriorities.contains(priority);
            return FilterChip(
              label: Text(
                priority,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedPriorities.add(priority);
                  } else {
                    _selectedPriorities.remove(priority);
                  }
                });
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: Theme.of(context).colorScheme.primary,
              checkmarkColor: Theme.of(context).colorScheme.onPrimary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCustomerFilter() {
    final customers = [
      'ABC Manufacturing',
      'XYZ Industries',
      'Tech Solutions Inc.',
      'Global Materials Co.'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 12.h),
        DropdownButtonFormField<String>(
          value: _selectedCustomer.isEmpty ? null : _selectedCustomer,
          decoration: const InputDecoration(
            hintText: 'Select customer',
            border: OutlineInputBorder(),
          ),
          items: [
            const DropdownMenuItem(value: '', child: Text('All Customers')),
            ...customers.map((customer) => DropdownMenuItem(
                  value: customer,
                  child: Text(customer),
                )),
          ],
          onChanged: (value) {
            setState(() {
              _selectedCustomer = value ?? '';
            });
          },
        ),
      ],
    );
  }
}
