import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class QuantitySpecificationWidget extends StatelessWidget {
  final TextEditingController quantityController;
  final String selectedUnit;
  final RangeValues priceRange;
  final Function(String) onUnitChanged;
  final Function(RangeValues) onPriceRangeChanged;

  const QuantitySpecificationWidget({
    super.key,
    required this.quantityController,
    required this.selectedUnit,
    required this.priceRange,
    required this.onUnitChanged,
    required this.onPriceRangeChanged,
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
                  Icons.straighten,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Quantity Specification',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    'Required',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Quantity input
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Required Quantity',
                      hintText: 'Enter quantity',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter quantity';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: selectedUnit,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'kg', child: Text('kg')),
                      DropdownMenuItem(value: 'g', child: Text('g')),
                      DropdownMenuItem(value: 'lb', child: Text('lb')),
                      DropdownMenuItem(value: 'oz', child: Text('oz')),
                      DropdownMenuItem(value: 'tons', child: Text('tons')),
                      DropdownMenuItem(value: 'pieces', child: Text('pieces')),
                      DropdownMenuItem(value: 'liters', child: Text('liters')),
                      DropdownMenuItem(
                          value: 'gallons', child: Text('gallons')),
                      DropdownMenuItem(value: 'm²', child: Text('m²')),
                      DropdownMenuItem(value: 'ft²', child: Text('ft²')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        onUnitChanged(value);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Price range slider
            Text(
              'Target Price Range (USD)',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),

            RangeSlider(
              values: priceRange,
              min: 0,
              max: 10000,
              divisions: 100,
              labels: RangeLabels(
                '\$${priceRange.start.round()}',
                '\$${priceRange.end.round()}',
              ),
              onChanged: onPriceRangeChanged,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Min: \$${priceRange.start.round()}',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  'Max: \$${priceRange.end.round()}',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Price estimation
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calculate,
                        size: 16.sp,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Estimated Total Cost',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    quantityController.text.isNotEmpty
                        ? '\$${((priceRange.start + priceRange.end) / 2 * int.tryParse(quantityController.text)!).toStringAsFixed(2)}'
                        : 'Enter quantity for estimation',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
}
