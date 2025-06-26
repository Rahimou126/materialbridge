import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AvailabilityWidget extends StatefulWidget {
  final bool isInStock;
  final DateTime? availabilityDate;
  final Function(bool) onStockStatusChanged;
  final Function(DateTime?) onDateChanged;

  const AvailabilityWidget({
    super.key,
    required this.isInStock,
    required this.availabilityDate,
    required this.onStockStatusChanged,
    required this.onDateChanged,
  });

  @override
  State<AvailabilityWidget> createState() => _AvailabilityWidgetState();
}

class _AvailabilityWidgetState extends State<AvailabilityWidget> {
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.availabilityDate ??
          DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: AppTheme.lightTheme.copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              headerBackgroundColor: AppTheme.lightTheme.colorScheme.primary,
              headerForegroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.lightTheme.colorScheme.onPrimary;
                }
                return AppTheme.lightTheme.colorScheme.onSurface;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.lightTheme.colorScheme.primary;
                }
                return Colors.transparent;
              }),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.onDateChanged(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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
              'Availability Status',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            _buildStockStatusToggle(),
            if (!widget.isInStock) ...[
              SizedBox(height: 2.h),
              _buildAvailabilityDatePicker(),
            ],
            SizedBox(height: 2.h),
            _buildAvailabilityInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildStockStatusToggle() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.lightTheme.colorScheme.outline),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onStockStatusChanged(true),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: widget.isInStock
                      ? AppTheme.lightTheme.colorScheme.secondary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: widget.isInStock
                          ? AppTheme.lightTheme.colorScheme.onSecondary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'In Stock',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: widget.isInStock
                            ? AppTheme.lightTheme.colorScheme.onSecondary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onStockStatusChanged(false),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: !widget.isInStock
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: !widget.isInStock
                          ? AppTheme.lightTheme.colorScheme.onTertiary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Out of Stock',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: !widget.isInStock
                            ? AppTheme.lightTheme.colorScheme.onTertiary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estimated Availability Date',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 0.5.h),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border:
                  Border.all(color: AppTheme.lightTheme.colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    widget.availabilityDate != null
                        ? _formatDate(widget.availabilityDate!)
                        : 'Select estimated date',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: widget.availabilityDate != null
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                CustomIconWidget(
                  iconName: 'arrow_drop_down',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityInfo() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: widget.isInStock
            ? AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'info',
            color: widget.isInStock
                ? AppTheme.lightTheme.colorScheme.secondary
                : AppTheme.lightTheme.colorScheme.tertiary,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              widget.isInStock
                  ? 'Material is currently available and ready for immediate shipment.'
                  : widget.availabilityDate != null
                      ? 'Material will be available by ${_formatDate(widget.availabilityDate!)}. Buyers can place advance orders.'
                      : 'Please set an estimated availability date for out-of-stock materials.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: widget.isInStock
                    ? AppTheme.lightTheme.colorScheme.secondary
                    : AppTheme.lightTheme.colorScheme.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
