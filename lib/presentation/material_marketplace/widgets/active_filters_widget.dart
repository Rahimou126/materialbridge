import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';


class ActiveFiltersWidget extends StatelessWidget {
  final Map<String, dynamic> activeFilters;
  final Function(String, dynamic) onRemoveFilter;
  final VoidCallback onClearAll;

  const ActiveFiltersWidget({
    super.key,
    required this.activeFilters,
    required this.onRemoveFilter,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> filterChips = [];

    // Add category filters
    if (activeFilters['categories'] != null &&
        (activeFilters['categories'] as List).isNotEmpty) {
      for (String category in activeFilters['categories'] as List<dynamic>) {
        filterChips.add(_buildFilterChip(
          context,
          category,
          () => onRemoveFilter('categories', category),
        ));
      }
    }

    // Add price range filter
    if (activeFilters['minPrice'] != null &&
        activeFilters['maxPrice'] != null) {
      filterChips.add(_buildFilterChip(
        context,
        '\$${(activeFilters['minPrice'] as num).round()}-\$${(activeFilters['maxPrice'] as num).round()}',
        () => onRemoveFilter('priceRange', null),
      ));
    }

    // Add availability filter
    if (activeFilters['availability'] != null) {
      filterChips.add(_buildFilterChip(
        context,
        activeFilters['availability'],
        () => onRemoveFilter('availability', null),
      ));
    }

    // Add location radius filter
    if (activeFilters['locationRadius'] != null) {
      filterChips.add(_buildFilterChip(
        context,
        '${(activeFilters['locationRadius'] as num).round()} km',
        () => onRemoveFilter('locationRadius', null),
      ));
    }

    // Add certification filters
    if (activeFilters['certifications'] != null &&
        (activeFilters['certifications'] as List).isNotEmpty) {
      for (String certification
          in activeFilters['certifications'] as List<dynamic>) {
        filterChips.add(_buildFilterChip(
          context,
          certification,
          () => onRemoveFilter('certifications', certification),
        ));
      }
    }

    if (filterChips.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withAlpha(51),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Filters',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: onClearAll,
                child: Text(
                  'Clear All',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 4.h,
            children: filterChips,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      BuildContext context, String label, VoidCallback onRemove) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: onRemove,
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.close,
                size: 14.sp,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
