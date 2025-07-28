import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';


class SortDropdownWidget extends StatelessWidget {
  final String selectedSort;
  final Function(String) onSortChanged;

  const SortDropdownWidget({
    super.key,
    required this.selectedSort,
    required this.onSortChanged,
  });

  static const List<String> sortOptions = [
    'Relevance',
    'Price: Low to High',
    'Price: High to Low',
    'Distance',
    'Rating',
    'Newest',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(77),
        ),
      ),
      child: DropdownButton<String>(
        value: selectedSort,
        onChanged: (String? newValue) {
          if (newValue != null) {
            onSortChanged(newValue);
          }
        },
        icon: Icon(
          Icons.keyboard_arrow_down,
          size: 20.sp,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        underline: const SizedBox.shrink(),
        isExpanded: true,
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        items: sortOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: [
                Icon(
                  _getSortIcon(value),
                  size: 16.sp,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 8.w),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getSortIcon(String sortType) {
    switch (sortType) {
      case 'Relevance':
        return Icons.sort;
      case 'Price: Low to High':
        return Icons.trending_up;
      case 'Price: High to Low':
        return Icons.trending_down;
      case 'Distance':
        return Icons.location_on;
      case 'Rating':
        return Icons.star;
      case 'Newest':
        return Icons.schedule;
      default:
        return Icons.sort;
    }
  }
}
