import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MaterialSelectionWidget extends StatefulWidget {
  final TextEditingController controller;
  final Map<String, dynamic>? selectedMaterial;
  final Function(Map<String, dynamic>) onMaterialSelected;

  const MaterialSelectionWidget({
    super.key,
    required this.controller,
    required this.selectedMaterial,
    required this.onMaterialSelected,
  });

  @override
  State<MaterialSelectionWidget> createState() =>
      _MaterialSelectionWidgetState();
}

class _MaterialSelectionWidgetState extends State<MaterialSelectionWidget> {
  final FocusNode _focusNode = FocusNode();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  final List<Map<String, dynamic>> _recentMaterials = [
    {
      'materialName': 'Stainless Steel 316L',
      'scientificName': 'Austenitic Stainless Steel',
      'imageUrl':
          'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'category': 'Metals',
      'id': '1',
    },
    {
      'materialName': 'Polyethylene Terephthalate',
      'scientificName': 'PET Polymer',
      'imageUrl':
          'https://images.unsplash.com/photo-1586075010923-2dd4570fb338?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'category': 'Plastics',
      'id': '2',
    },
    {
      'materialName': 'Titanium Dioxide',
      'scientificName': 'TiO₂',
      'imageUrl':
          'https://images.unsplash.com/photo-1532634993-15f421e42ec0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'category': 'Chemicals',
      'id': '3',
    },
  ];

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _searchMaterials(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simulate search with delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _searchResults = _recentMaterials
              .where((material) =>
                  material['materialName']
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  material['scientificName']
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  material['category']
                      .toLowerCase()
                      .contains(query.toLowerCase()))
              .toList();
          _isSearching = false;
        });
      }
    });
  }

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
                  Icons.inventory_2,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Material Selection',
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

            // Search field
            TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                labelText: 'Search materials',
                hintText: 'Enter material name, scientific name, or category',
                prefixIcon: Icon(
                  Icons.search,
                  size: 20.sp,
                ),
                suffixIcon: _isSearching
                    ? Padding(
                        padding: EdgeInsets.all(12.w),
                        child: SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
              onChanged: _searchMaterials,
              validator: (value) {
                if (widget.selectedMaterial == null) {
                  return 'Please select a material';
                }
                return null;
              },
            ),

            // Selected material display
            if (widget.selectedMaterial != null) ...[
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.selectedMaterial!['imageUrl'] ?? '',
                        width: 40.w,
                        height: 40.h,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 40.w,
                          height: 40.h,
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          child: Icon(
                            Icons.image,
                            size: 20.sp,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 40.w,
                          height: 40.h,
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          child: Icon(
                            Icons.broken_image,
                            size: 20.sp,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.selectedMaterial!['materialName'] ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            widget.selectedMaterial!['scientificName'] ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.controller.clear();
                          _searchResults.clear();
                        });
                        widget.onMaterialSelected({});
                      },
                      icon: Icon(
                        Icons.close,
                        size: 20.sp,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Search results or recent materials
            if (_focusNode.hasFocus || _searchResults.isNotEmpty) ...[
              SizedBox(height: 16.h),
              Text(
                _searchResults.isNotEmpty
                    ? 'Search Results'
                    : 'Recent Materials',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                constraints: BoxConstraints(maxHeight: 200.h),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.isNotEmpty
                      ? _searchResults.length
                      : _recentMaterials.length,
                  itemBuilder: (context, index) {
                    final material = _searchResults.isNotEmpty
                        ? _searchResults[index]
                        : _recentMaterials[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: CachedNetworkImage(
                          imageUrl: material['imageUrl'] ?? '',
                          width: 40.w,
                          height: 40.h,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 40.w,
                            height: 40.h,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            child: Icon(
                              Icons.image,
                              size: 20.sp,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 40.w,
                            height: 40.h,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            child: Icon(
                              Icons.broken_image,
                              size: 20.sp,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        material['materialName'] ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        material['scientificName'] ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          material['category'] ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                        ),
                      ),
                      onTap: () {
                        widget.onMaterialSelected(material);
                        _focusNode.unfocus();
                        setState(() {
                          _searchResults.clear();
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
