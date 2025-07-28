import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class FormProgressWidget extends StatelessWidget {
  final double progress;
  final Map<String, bool> sectionCompletion;

  const FormProgressWidget({
    super.key,
    required this.progress,
    required this.sectionCompletion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1.0,
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
                'Form Progress',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                '${(progress * 100).round()}% Complete',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Progress bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: 12.h),

          // Section indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionIndicator(
                context,
                'Material',
                Icons.inventory_2,
                sectionCompletion['material'] ?? false,
              ),
              _buildSectionIndicator(
                context,
                'Quantity',
                Icons.straighten,
                sectionCompletion['quantity'] ?? false,
              ),
              _buildSectionIndicator(
                context,
                'Delivery',
                Icons.local_shipping,
                sectionCompletion['delivery'] ?? false,
              ),
              _buildSectionIndicator(
                context,
                'Specs',
                Icons.description,
                sectionCompletion['specifications'] ?? false,
              ),
              _buildSectionIndicator(
                context,
                'Payment',
                Icons.payment,
                sectionCompletion['payment'] ?? false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionIndicator(
    BuildContext context,
    String title,
    IconData icon,
    bool isCompleted,
  ) {
    return Column(
      children: [
        Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: isCompleted
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted ? Icons.check : icon,
            size: 16.sp,
            color: isCompleted
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: isCompleted
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
