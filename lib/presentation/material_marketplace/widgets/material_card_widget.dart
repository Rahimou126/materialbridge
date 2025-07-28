import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_widget.dart';

class MaterialCardWidget extends StatelessWidget {
  final String materialName;
  final String scientificName;
  final String imageUrl;
  final String supplierName;
  final double rating;
  final int reviewCount;
  final String priceRange;
  final String availability;
  final String category;
  final String estimatedTime;
  final String country;
  final void Function()? onTap;
  final void Function()? onFavorite;
  final void Function()? onShare;
  final bool isFavorite;

  const MaterialCardWidget({
    super.key,
    required this.materialName,
    required this.scientificName,
    required this.imageUrl,
    required this.supplierName,
    required this.rating,
    required this.reviewCount,
    required this.priceRange,
    required this.availability,
    required this.category,
    required this.estimatedTime,
    required this.country,
    this.onTap,
    this.onFavorite,
    this.onShare,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = availability.toLowerCase() == 'available';

    return Card(
        elevation: 2,
        margin: EdgeInsets.all(8.w),
        child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withAlpha(51))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image and favorite button
                      Stack(children: [
                        Container(
                            height: 120.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8.0)),
                                color: Theme.of(context).colorScheme.surface),
                            child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8.0)),
                                child: CustomImageWidget(
                                    imageUrl: imageUrl,
                                    height: 120.h,
                                    width: double.infinity,
                                    fit: BoxFit.cover))),
                        Positioned(
                            top: 8.h,
                            right: 8.w,
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Container(
                                  width: 32.w,
                                  height: 32.h,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(230),
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  child: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: onShare,
                                      icon: Icon(Icons.share,
                                          size: 16.sp,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface))),
                              SizedBox(width: 4.w),
                              Container(
                                  width: 32.w,
                                  height: 32.h,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(230),
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  child: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: onFavorite,
                                      icon: Icon(
                                          isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          size: 16.sp,
                                          color: isFavorite
                                              ? Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface))),
                            ])),
                        // Availability badge
                        Positioned(
                            top: 8.h,
                            left: 8.w,
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                    color: isAvailable
                                        ? Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withAlpha(230)
                                        : Theme.of(context)
                                            .colorScheme
                                            .error
                                            .withAlpha(230),
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: Text(availability,
                                    style: GoogleFonts.inter(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white)))),
                      ]),
                      // Material information
                      Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Material name
                                Text(materialName,
                                    style: GoogleFonts.inter(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                SizedBox(height: 2.h),
                                // Scientific name
                                Text(scientificName,
                                    style: GoogleFonts.inter(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                        fontStyle: FontStyle.italic),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                SizedBox(height: 6.h),
                                // Category
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    child: Text(category,
                                        style: GoogleFonts.inter(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer))),
                                SizedBox(height: 8.h),
                                // Supplier and rating
                                Row(children: [
                                  Expanded(
                                      child: Text(supplierName,
                                          style: GoogleFonts.inter(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis)),
                                  Icon(Icons.star,
                                      size: 12.sp, color: Colors.amber),
                                  SizedBox(width: 2.w),
                                  Text('$rating ($reviewCount)',
                                      style: GoogleFonts.inter(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant)),
                                ]),
                                SizedBox(height: 6.h),
                                // Price range
                                Text(priceRange,
                                    style: GoogleFonts.inter(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                                SizedBox(height: 4.h),
                                // Country and estimated time
                                Row(children: [
                                  Icon(Icons.location_on,
                                      size: 12.sp,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant),
                                  SizedBox(width: 2.w),
                                  Text(country,
                                      style: GoogleFonts.inter(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant)),
                                  const Spacer(),
                                  if (!isAvailable) ...[
                                    Icon(Icons.schedule,
                                        size: 12.sp,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant),
                                    SizedBox(width: 2.w),
                                    Text(estimatedTime,
                                        style: GoogleFonts.inter(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant)),
                                  ],
                                ]),
                              ])),
                    ]))));
  }
}
