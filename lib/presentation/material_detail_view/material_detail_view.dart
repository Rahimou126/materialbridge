import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import './widgets/action_buttons_widget.dart';
import './widgets/expandable_section_widget.dart';
import './widgets/material_image_carousel_widget.dart';
import './widgets/material_info_card_widget.dart';

class MaterialDetailView extends StatefulWidget {
  const MaterialDetailView({super.key});

  @override
  State<MaterialDetailView> createState() => _MaterialDetailViewState();
}

class _MaterialDetailViewState extends State<MaterialDetailView> {
  Map<String, dynamic>? _material;
  bool _isInWatchlist = false;
  bool _isFavorite = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get material data from route arguments
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      _material = arguments;
    }
  }

  void _onRequestQuote() {
    // Navigate to purchase request form
    // For now, show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Request quote feature coming soon'),
        action: SnackBarAction(label: 'OK', onPressed: () {})));
  }

  void _onMessageSupplier() {
    // Implement message supplier functionality
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Message supplier feature coming soon'),
        action: SnackBarAction(label: 'OK', onPressed: () {})));
  }

  void _onAddToWatchlist() {
    setState(() {
      _isInWatchlist = !_isInWatchlist;
    });

    Fluttertoast.showToast(
        msg: _isInWatchlist ? 'Added to watchlist' : 'Removed from watchlist');
  }

  void _onFavoriteToggle() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    Fluttertoast.showToast(
        msg: _isFavorite ? 'Added to favorites' : 'Removed from favorites');
  }

  void _onShare() {
    // Implement share functionality
    Fluttertoast.showToast(msg: 'Share functionality coming soon');
  }

  void _onReport() {
    // Implement report functionality
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Report material feature coming soon'),
        action: SnackBarAction(label: 'OK', onPressed: () {})));
  }

  @override
  Widget build(BuildContext context) {
    if (_material == null) {
      return Scaffold(
          appBar: AppBar(
              title: Text('Material Details',
                  style: GoogleFonts.inter(
                      fontSize: 20.sp, fontWeight: FontWeight.w600))),
          body: const Center(child: Text('No material data available')));
    }

    final bool isAvailable =
        _material!['availability']?.toLowerCase() == 'available';
    final List<String> imageUrls = [_material!['imageUrl']];

    return Scaffold(
        body: CustomScrollView(slivers: [
          // Sticky header with material name and actions
          SliverAppBar(
              expandedHeight: 300.h,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  title: Text(_material!['materialName'] ?? 'Material',
                      style: GoogleFonts.inter(
                          fontSize: 16.sp, fontWeight: FontWeight.w600)),
                  background: MaterialImageCarouselWidget(
                      imageUrls: imageUrls,
                      materialName: _material!['materialName'] ?? 'Material')),
              actions: [
                IconButton(
                    onPressed: _onFavoriteToggle,
                    icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : null)),
                IconButton(onPressed: _onShare, icon: const Icon(Icons.share)),
                PopupMenuButton(
                    itemBuilder: (context) => [
                          PopupMenuItem(
                              value: 'report',
                              child: Row(children: [
                                Icon(Icons.report,
                                    size: 20.sp,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                SizedBox(width: 8.w),
                                Text('Report',
                                    style: GoogleFonts.inter(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500)),
                              ])),
                        ],
                    onSelected: (value) {
                      if (value == 'report') {
                        _onReport();
                      }
                    }),
              ]),
          // Material content
          SliverList(
              delegate: SliverChildListDelegate([
            // Material information card
            MaterialInfoCardWidget(
                materialName: _material!['materialName'] ?? '',
                scientificName: _material!['scientificName'] ?? '',
                priceRange: _material!['priceRange'] ?? '',
                minimumOrder: _material!['minimumOrder'] ?? '',
                availability: _material!['availability'] ?? '',
                supplierName: _material!['supplierName'] ?? '',
                rating: _material!['rating']?.toDouble() ?? 0.0,
                reviewCount: _material!['reviewCount'] ?? 0,
                category: _material!['category'] ?? '',
                country: _material!['country'] ?? ''),
            SizedBox(height: 8.h),
            // Description section
            ExpandableSectionWidget(
                title: 'Description',
                icon: Icons.description,
                initiallyExpanded: true,
                content: Text(
                    _material!['description'] ?? 'No description available.',
                    style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.5))),
            // Technical specifications section
            ExpandableSectionWidget(
                title: 'Technical Specifications',
                icon: Icons.science,
                content: _buildTechnicalSpecs()),
            // Certifications section
            ExpandableSectionWidget(
                title: 'Certifications',
                icon: Icons.verified,
                content: _buildCertifications()),
            // Shipping information section
            ExpandableSectionWidget(
                title: 'Shipping Information',
                icon: Icons.local_shipping,
                content: _buildShippingInfo()),
            // Supplier profile section
            ExpandableSectionWidget(
                title: 'Supplier Profile',
                icon: Icons.business,
                content: _buildSupplierProfile()),
            // Related materials section
            _buildRelatedMaterials(),
            // Reviews section
            _buildReviewsSection(),
            // Extra padding for action buttons
            SizedBox(height: 100.h),
          ])),
        ]),
        // Fixed action buttons at bottom
        bottomNavigationBar: ActionButtonsWidget(
            onRequestQuote: _onRequestQuote,
            onMessageSupplier: _onMessageSupplier,
            onAddToWatchlist: _onAddToWatchlist,
            isInWatchlist: _isInWatchlist,
            isAvailable: isAvailable));
  }

  Widget _buildTechnicalSpecs() {
    final Map<String, dynamic> specs = _material!['technicalSpecs'] ?? {};

    if (specs.isEmpty) {
      return Text('No technical specifications available.',
          style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurfaceVariant));
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: specs.entries.map((entry) {
          return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                    width: 120.w,
                    child: Text('${entry.key}:',
                        style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant))),
                Expanded(
                    child: Text(entry.value.toString(),
                        style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onSurface))),
              ]));
        }).toList());
  }

  Widget _buildCertifications() {
    final List<String> certifications =
        (_material!['certifications'] as List<dynamic>?)?.cast<String>() ?? [];

    if (certifications.isEmpty) {
      return Text('No certifications available.',
          style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurfaceVariant));
    }

    return Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: certifications.map((cert) {
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16.0)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.verified,
                    size: 16.sp, color: Theme.of(context).colorScheme.primary),
                SizedBox(width: 4.w),
                Text(cert,
                    style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer)),
              ]));
        }).toList());
  }

  Widget _buildShippingInfo() {
    final String shippingInfo =
        _material!['shippingInfo'] ?? 'No shipping information available.';

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(Icons.local_shipping,
            size: 20.sp, color: Theme.of(context).colorScheme.primary),
        SizedBox(width: 8.w),
        Text('Shipping Details',
            style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface)),
      ]),
      SizedBox(height: 8.h),
      Text(shippingInfo,
          style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurface)),
    ]);
  }

  Widget _buildSupplierProfile() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.business,
                color: Theme.of(context).colorScheme.onPrimary, size: 20.sp)),
        SizedBox(width: 12.w),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_material!['supplierName'] ?? 'Unknown Supplier',
              style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface)),
          SizedBox(height: 2.h),
          Row(children: [
            Icon(Icons.verified,
                size: 14.sp, color: Theme.of(context).colorScheme.primary),
            SizedBox(width: 4.w),
            Text('Verified Supplier',
                style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary)),
          ]),
        ])),
      ]),
      SizedBox(height: 16.h),
      Row(children: [
        _buildSupplierStat('Response Time', '< 2 hours'),
        SizedBox(width: 16.w),
        _buildSupplierStat('Country', _material!['country'] ?? 'Unknown'),
      ]),
    ]);
  }

  Widget _buildSupplierStat(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurfaceVariant)),
      SizedBox(height: 2.h),
      Text(value,
          style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface)),
    ]);
  }

  Widget _buildRelatedMaterials() {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        child: Padding(
            padding: EdgeInsets.all(16.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Related Materials',
                  style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface)),
              SizedBox(height: 12.h),
              Text('Related materials feature coming soon.',
                  style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ])));
  }

  Widget _buildReviewsSection() {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        child: Padding(
            padding: EdgeInsets.all(16.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Reviews',
                    style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface)),
                Row(children: [
                  Icon(Icons.star, size: 16.sp, color: Colors.amber),
                  SizedBox(width: 4.w),
                  Text(
                      '${_material!['rating']} (${_material!['reviewCount']} reviews)',
                      style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface)),
                ]),
              ]),
              SizedBox(height: 12.h),
              Text('Customer reviews feature coming soon.',
                  style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ])));
  }
}
