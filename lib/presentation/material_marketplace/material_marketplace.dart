import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/active_filters_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/material_card_widget.dart';
import './widgets/search_filter_widget.dart';
import './widgets/sort_dropdown_widget.dart';

class MaterialMarketplace extends StatefulWidget {
  const MaterialMarketplace({super.key});

  @override
  State<MaterialMarketplace> createState() => _MaterialMarketplaceState();
}

class _MaterialMarketplaceState extends State<MaterialMarketplace>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController();

  String _searchQuery = '';
  String _selectedSort = 'Relevance';
  Map<String, dynamic> _activeFilters = {};
  bool _isLoading = false;
  bool _hasMoreData = true;
  final List<Map<String, dynamic>> _materials = [];
  final Set<String> _favorites = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading data
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _materials.addAll(_generateMockMaterials());
        _isLoading = false;
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _materials.addAll(_generateMockMaterials());
          _isLoading = false;
          if (_materials.length >= 50) {
            _hasMoreData = false;
          }
        });
      }
    });
  }

  void _onRefresh() {
    _refreshController.refreshCompleted();
    setState(() {
      _materials.clear();
      _hasMoreData = true;
    });
    _loadInitialData();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    // Implement search logic
  }

  void _onFilterPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _activeFilters,
        onApplyFilters: (filters) {
          setState(() {
            _activeFilters = filters;
          });
          // Implement filter logic
        },
        onClearFilters: () {
          setState(() {
            _activeFilters.clear();
          });
        },
      ),
    );
  }

  void _onVoiceSearch() {
    // Implement voice search
    Fluttertoast.showToast(msg: 'Voice search not implemented yet');
  }

  void _onSortChanged(String sortType) {
    setState(() {
      _selectedSort = sortType;
    });
    // Implement sort logic
  }

  void _onRemoveFilter(String filterType, dynamic value) {
    setState(() {
      if (filterType == 'categories' && _activeFilters['categories'] != null) {
        _activeFilters['categories'].remove(value);
        if (_activeFilters['categories'].isEmpty) {
          _activeFilters.remove('categories');
        }
      } else if (filterType == 'certifications' &&
          _activeFilters['certifications'] != null) {
        _activeFilters['certifications'].remove(value);
        if (_activeFilters['certifications'].isEmpty) {
          _activeFilters.remove('certifications');
        }
      } else {
        _activeFilters.remove(filterType);
      }
    });
  }

  void _onClearAllFilters() {
    setState(() {
      _activeFilters.clear();
    });
  }

  void _onMaterialTap(Map<String, dynamic> material) {
    Navigator.pushNamed(
      context,
      AppRoutes.materialDetailView,
      arguments: material,
    );
  }

  void _onFavoriteToggle(String materialId) {
    setState(() {
      if (_favorites.contains(materialId)) {
        _favorites.remove(materialId);
      } else {
        _favorites.add(materialId);
      }
    });
  }

  void _onShare(Map<String, dynamic> material) {
    // Implement share functionality
    Fluttertoast.showToast(msg: 'Share functionality not implemented yet');
  }

  List<Map<String, dynamic>> _generateMockMaterials() {
    final List<Map<String, dynamic>> mockMaterials = [
      {
        'id': '1',
        'materialName': 'Stainless Steel 316L',
        'scientificName': 'Austenitic Stainless Steel',
        'imageUrl':
            'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
        'supplierName': 'MetalCorp Industries',
        'rating': 4.8,
        'reviewCount': 156,
        'priceRange': '\$45-65/kg',
        'availability': 'Available',
        'category': 'Metals',
        'estimatedTime': '',
        'country': 'Germany',
        'description':
            'High-grade stainless steel with excellent corrosion resistance.',
        'technicalSpecs': {
          'composition': 'Fe, Cr 16-18%, Ni 10-14%, Mo 2-3%',
          'density': '8.0 g/cm³',
          'meltingPoint': '1400-1450°C',
          'tensileStrength': '515-620 MPa',
        },
        'certifications': ['ISO 9001', 'CE Marking'],
        'minimumOrder': '100 kg',
        'shippingInfo': 'Ships within 3-5 business days',
      },
      {
        'id': '2',
        'materialName': 'Polyethylene Terephthalate',
        'scientificName': 'PET Polymer',
        'imageUrl':
            'https://images.unsplash.com/photo-1586075010923-2dd4570fb338?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
        'supplierName': 'PlasticTech Solutions',
        'rating': 4.5,
        'reviewCount': 89,
        'priceRange': '\$2.20-3.80/kg',
        'availability': 'Out of Stock',
        'category': 'Plastics',
        'estimatedTime': '2-3 weeks',
        'country': 'China',
        'description':
            'Versatile thermoplastic polymer for various applications.',
        'technicalSpecs': {
          'density': '1.38 g/cm³',
          'meltingPoint': '250-260°C',
          'tensileStrength': '50-70 MPa',
          'flexuralModulus': '2.8-3.1 GPa',
        },
        'certifications': ['ISO 14001', 'FDA Approved'],
        'minimumOrder': '500 kg',
        'shippingInfo': 'Ships within 2-3 weeks',
      },
      {
        'id': '3',
        'materialName': 'Titanium Dioxide',
        'scientificName': 'TiO₂',
        'imageUrl':
            'https://images.unsplash.com/photo-1532634993-15f421e42ec0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
        'supplierName': 'Chemical Innovations Inc.',
        'rating': 4.7,
        'reviewCount': 124,
        'priceRange': '\$1.80-2.50/kg',
        'availability': 'Available',
        'category': 'Chemicals',
        'estimatedTime': '',
        'country': 'USA',
        'description':
            'White pigment with excellent opacity and UV resistance.',
        'technicalSpecs': {
          'purity': '99.5%',
          'particleSize': '0.2-0.3 μm',
          'density': '4.23 g/cm³',
          'refractiveIndex': '2.76',
        },
        'certifications': ['ISO 9001', 'RoHS Compliant'],
        'minimumOrder': '25 kg',
        'shippingInfo': 'Ships within 1-2 business days',
      },
      {
        'id': '4',
        'materialName': 'Carbon Fiber Composite',
        'scientificName': 'CFRP',
        'imageUrl':
            'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
        'supplierName': 'Advanced Materials Co.',
        'rating': 4.9,
        'reviewCount': 78,
        'priceRange': '\$25-45/m²',
        'availability': 'Available',
        'category': 'Composites',
        'estimatedTime': '',
        'country': 'Japan',
        'description':
            'High-strength, lightweight carbon fiber reinforced polymer.',
        'technicalSpecs': {
          'density': '1.6 g/cm³',
          'tensileStrength': '3500-4000 MPa',
          'youngModulus': '230-240 GPa',
          'thickness': '0.5-2.0 mm',
        },
        'certifications': ['ISO 9001', 'AS9100'],
        'minimumOrder': '10 m²',
        'shippingInfo': 'Ships within 5-7 business days',
      },
      {
        'id': '5',
        'materialName': 'Borosilicate Glass',
        'scientificName': 'Borosilicate',
        'imageUrl':
            'https://images.unsplash.com/photo-1589735782596-266e5d066aed?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
        'supplierName': 'Crystal Glass Industries',
        'rating': 4.6,
        'reviewCount': 92,
        'priceRange': '\$8.50-12.00/kg',
        'availability': 'Pre-order',
        'category': 'Glass',
        'estimatedTime': '1-2 weeks',
        'country': 'Italy',
        'description':
            'Low thermal expansion glass with high chemical resistance.',
        'technicalSpecs': {
          'density': '2.23 g/cm³',
          'thermalExpansion': '3.3 × 10⁻⁶ K⁻¹',
          'softening point': '821°C',
          'chemicalResistance': 'Excellent',
        },
        'certifications': ['ISO 9001', 'CE Marking'],
        'minimumOrder': '50 kg',
        'shippingInfo': 'Ships within 1-2 weeks',
      },
      {
        'id': '6',
        'materialName': 'Natural Rubber',
        'scientificName': 'Hevea brasiliensis',
        'imageUrl':
            'https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
        'supplierName': 'Tropical Rubber Ltd.',
        'rating': 4.4,
        'reviewCount': 67,
        'priceRange': '\$1.50-2.20/kg',
        'availability': 'Available',
        'category': 'Rubber',
        'estimatedTime': '',
        'country': 'Thailand',
        'description': 'High-quality natural rubber with excellent elasticity.',
        'technicalSpecs': {
          'density': '0.92 g/cm³',
          'tensileStrength': '25-30 MPa',
          'elongation': '700-800%',
          'hardness': '40-60 Shore A',
        },
        'certifications': ['ISO 9001', 'FSC Certified'],
        'minimumOrder': '200 kg',
        'shippingInfo': 'Ships within 7-10 business days',
      },
    ];
    return mockMaterials;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Material Marketplace',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                // Implement location toggle
              },
              icon: Icon(
                Icons.location_on,
                size: 24.sp,
              ),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Marketplace'),
              Tab(text: 'Categories'),
              Tab(text: 'Favorites'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Marketplace tab
            _buildMarketplaceTab(),
            // Categories tab
            _buildCategoriesTab(),
            // Favorites tab
            _buildFavoritesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketplaceTab() {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: Column(
        children: [
          // Search and filter
          SearchFilterWidget(
            onSearchChanged: _onSearchChanged,
            onFilterPressed: _onFilterPressed,
            onVoiceSearch: _onVoiceSearch,
            searchQuery: _searchQuery,
            hasActiveFilters: _activeFilters.isNotEmpty,
          ),
          // Active filters
          ActiveFiltersWidget(
            activeFilters: _activeFilters,
            onRemoveFilter: _onRemoveFilter,
            onClearAll: _onClearAllFilters,
          ),
          // Sort dropdown
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: SortDropdownWidget(
              selectedSort: _selectedSort,
              onSortChanged: _onSortChanged,
            ),
          ),
          // Materials grid
          Expanded(
            child: _materials.isEmpty && _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _materials.isEmpty
                    ? _buildEmptyState()
                    : GridView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(8.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 8.w,
                          mainAxisSpacing: 8.h,
                        ),
                        itemCount: _materials.length + (_hasMoreData ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _materials.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final material = _materials[index];
                          return MaterialCardWidget(
                            materialName: material['materialName'],
                            scientificName: material['scientificName'],
                            imageUrl: material['imageUrl'],
                            supplierName: material['supplierName'],
                            rating: material['rating'],
                            reviewCount: material['reviewCount'],
                            priceRange: material['priceRange'],
                            availability: material['availability'],
                            category: material['category'],
                            estimatedTime: material['estimatedTime'],
                            country: material['country'],
                            isFavorite: _favorites.contains(material['id']),
                            onTap: () => _onMaterialTap(material),
                            onFavorite: () => _onFavoriteToggle(material['id']),
                            onShare: () => _onShare(material),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return Center(
      child: Text(
        'Categories view - Coming Soon',
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFavoritesTab() {
    final favoriteMaterials = _materials
        .where((material) => _favorites.contains(material['id']))
        .toList();

    if (favoriteMaterials.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 16.h),
            Text(
              'No favorites yet',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Start browsing materials to add to your favorites',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(8.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
      ),
      itemCount: favoriteMaterials.length,
      itemBuilder: (context, index) {
        final material = favoriteMaterials[index];
        return MaterialCardWidget(
          materialName: material['materialName'],
          scientificName: material['scientificName'],
          imageUrl: material['imageUrl'],
          supplierName: material['supplierName'],
          rating: material['rating'],
          reviewCount: material['reviewCount'],
          priceRange: material['priceRange'],
          availability: material['availability'],
          category: material['category'],
          estimatedTime: material['estimatedTime'],
          country: material['country'],
          isFavorite: true,
          onTap: () => _onMaterialTap(material),
          onFavorite: () => _onFavoriteToggle(material['id']),
          onShare: () => _onShare(material),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64.sp,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 16.h),
          Text(
            'No materials found',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your search or filters',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
