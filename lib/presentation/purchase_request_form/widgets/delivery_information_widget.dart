import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class DeliveryInformationWidget extends StatelessWidget {
  final TextEditingController addressController;
  final TextEditingController specialInstructionsController;
  final DateTime? requiredDate;
  final DateTime? preferredDate;
  final String urgency;
  final String shippingMethod;
  final Function(DateTime) onRequiredDateChanged;
  final Function(DateTime) onPreferredDateChanged;
  final Function(String) onUrgencyChanged;
  final Function(String) onShippingMethodChanged;

  const DeliveryInformationWidget({
    super.key,
    required this.addressController,
    required this.specialInstructionsController,
    required this.requiredDate,
    required this.preferredDate,
    required this.urgency,
    required this.shippingMethod,
    required this.onRequiredDateChanged,
    required this.onPreferredDateChanged,
    required this.onUrgencyChanged,
    required this.onShippingMethodChanged,
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
                  Icons.local_shipping,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Delivery Information',
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

            // Delivery address
            TextFormField(
              controller: addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Delivery Address',
                hintText: 'Enter complete delivery address',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter delivery address';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Saved locations
            Row(
              children: [
                Icon(
                  Icons.bookmark,
                  size: 16.sp,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Saved Locations',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _buildLocationChip(context, 'Main Factory', 'Chicago, IL'),
                _buildLocationChip(context, 'Warehouse', 'Detroit, MI'),
                _buildLocationChip(context, 'Office', 'New York, NY'),
              ],
            ),
            SizedBox(height: 16.h),

            // Required date
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: requiredDate ??
                            DateTime.now().add(const Duration(days: 7)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        onRequiredDateChanged(date);
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Required Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        requiredDate != null
                            ? '${requiredDate!.day}/${requiredDate!.month}/${requiredDate!.year}'
                            : 'Select date',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: requiredDate != null
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: preferredDate ??
                            DateTime.now().add(const Duration(days: 5)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        onPreferredDateChanged(date);
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Preferred Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        preferredDate != null
                            ? '${preferredDate!.day}/${preferredDate!.month}/${preferredDate!.year}'
                            : 'Select date',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: preferredDate != null
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Urgency and shipping method
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: urgency,
                    decoration: const InputDecoration(
                      labelText: 'Urgency',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Low', child: Text('Low')),
                      DropdownMenuItem(
                          value: 'Standard', child: Text('Standard')),
                      DropdownMenuItem(value: 'High', child: Text('High')),
                      DropdownMenuItem(value: 'Urgent', child: Text('Urgent')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        onUrgencyChanged(value);
                      }
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: shippingMethod,
                    decoration: const InputDecoration(
                      labelText: 'Shipping Method',
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'Standard', child: Text('Standard')),
                      DropdownMenuItem(
                          value: 'Express', child: Text('Express')),
                      DropdownMenuItem(
                          value: 'Overnight', child: Text('Overnight')),
                      DropdownMenuItem(
                          value: 'Freight', child: Text('Freight')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        onShippingMethodChanged(value);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Urgency indicator
            _buildUrgencyIndicator(context),
            SizedBox(height: 16.h),

            // Special instructions
            TextFormField(
              controller: specialInstructionsController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Special Handling Instructions',
                hintText: 'Enter any special handling requirements',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationChip(BuildContext context, String name, String address) {
    return InkWell(
      onTap: () {
        addressController.text = address;
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on,
              size: 14.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 4.w),
            Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrgencyIndicator(BuildContext context) {
    Color indicatorColor;
    IconData indicatorIcon;
    String description;

    switch (urgency) {
      case 'Low':
        indicatorColor = Colors.green;
        indicatorIcon = Icons.schedule;
        description = 'Flexible delivery timeline';
        break;
      case 'Standard':
        indicatorColor = Colors.blue;
        indicatorIcon = Icons.access_time;
        description = 'Standard delivery timing';
        break;
      case 'High':
        indicatorColor = Colors.orange;
        indicatorIcon = Icons.priority_high;
        description = 'Priority delivery required';
        break;
      case 'Urgent':
        indicatorColor = Colors.red;
        indicatorIcon = Icons.warning;
        description = 'Urgent delivery - rush order';
        break;
      default:
        indicatorColor = Colors.blue;
        indicatorIcon = Icons.access_time;
        description = 'Standard delivery timing';
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: indicatorColor.withAlpha(26),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: indicatorColor.withAlpha(77)),
      ),
      child: Row(
        children: [
          Icon(
            indicatorIcon,
            size: 16.sp,
            color: indicatorColor,
          ),
          SizedBox(width: 8.w),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: indicatorColor,
            ),
          ),
        ],
      ),
    );
  }
}
