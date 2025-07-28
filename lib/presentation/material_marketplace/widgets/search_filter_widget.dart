import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';


class SearchFilterWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onFilterPressed;
  final VoidCallback onVoiceSearch;
  final String searchQuery;
  final bool hasActiveFilters;

  const SearchFilterWidget({
    super.key,
    required this.onSearchChanged,
    required this.onFilterPressed,
    required this.onVoiceSearch,
    required this.searchQuery,
    this.hasActiveFilters = false,
  });

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
    _searchController.addListener(() {
      widget.onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withAlpha(51),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Search field
          Expanded(
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(77),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withAlpha(77),
                ),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search materials...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            widget.onSearchChanged('');
                          },
                          icon: Icon(
                            Icons.clear,
                            size: 20.sp,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        )
                      : IconButton(
                          onPressed: widget.onVoiceSearch,
                          icon: Icon(
                            Icons.mic,
                            size: 20.sp,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                ),
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  _searchFocusNode.unfocus();
                },
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Filter button
          Container(
            height: 40.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: widget.hasActiveFilters
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(77),
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: widget.hasActiveFilters
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withAlpha(77),
              ),
            ),
            child: IconButton(
              onPressed: widget.onFilterPressed,
              icon: Stack(
                children: [
                  Icon(
                    Icons.tune,
                    size: 20.sp,
                    color: widget.hasActiveFilters
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  if (widget.hasActiveFilters)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
