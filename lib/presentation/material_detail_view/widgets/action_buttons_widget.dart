import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';


class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onRequestQuote;
  final VoidCallback onMessageSupplier;
  final VoidCallback onAddToWatchlist;
  final bool isInWatchlist;
  final bool isAvailable;

  const ActionButtonsWidget({
    super.key,
    required this.onRequestQuote,
    required this.onMessageSupplier,
    required this.onAddToWatchlist,
    this.isInWatchlist = false,
    this.isAvailable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withAlpha(51),
          ),
        ),
      ),
      child: Column(
        children: [
          // Primary action - Request Quote
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isAvailable ? onRequestQuote : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isAvailable
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withAlpha(31),
                foregroundColor: isAvailable
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface.withAlpha(97),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.request_quote,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    isAvailable ? 'Request Quote' : 'Currently Unavailable',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Secondary actions
          Row(
            children: [
              // Message Supplier
              Expanded(
                child: OutlinedButton(
                  onPressed: onMessageSupplier,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.message,
                        size: 18.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Message',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Add to Watchlist
              Expanded(
                child: OutlinedButton(
                  onPressed: onAddToWatchlist,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    side: BorderSide(
                      color: isInWatchlist
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                    ),
                    backgroundColor: isInWatchlist
                        ? Theme.of(context).colorScheme.primary.withAlpha(26)
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                        size: 18.sp,
                        color: isInWatchlist
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        isInWatchlist ? 'Watching' : 'Watchlist',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: isInWatchlist
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
