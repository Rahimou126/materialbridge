import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class BatchActionWidget extends StatelessWidget {
  final int selectedCount;
  final Function(String) onBatchAction;

  const BatchActionWidget({
    super.key,
    required this.selectedCount,
    required this.onBatchAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 20.sp,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          SizedBox(width: 8.w),
          Text(
            '$selectedCount selected',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              IconButton(
                onPressed: () => onBatchAction('mark_priority'),
                icon: Icon(
                  Icons.priority_high,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                tooltip: 'Mark as Priority',
              ),
              IconButton(
                onPressed: () => onBatchAction('send_quote'),
                icon: Icon(
                  Icons.send,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                tooltip: 'Send Quote',
              ),
              IconButton(
                onPressed: () => _showDeleteConfirmation(context),
                icon: Icon(
                  Icons.delete,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.error,
                ),
                tooltip: 'Delete',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Requests',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete $selectedCount selected request${selectedCount == 1 ? '' : 's'}?',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onBatchAction('delete');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
