import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class AdditionalRequirementsWidget extends StatelessWidget {
  final TextEditingController controller;
  final List<String> certifications;
  final List<String> packagingSpecs;
  final Function(String) onCertificationAdded;
  final Function(String) onCertificationRemoved;
  final Function(String) onPackagingSpecAdded;
  final Function(String) onPackagingSpecRemoved;

  const AdditionalRequirementsWidget({
    super.key,
    required this.controller,
    required this.certifications,
    required this.packagingSpecs,
    required this.onCertificationAdded,
    required this.onCertificationRemoved,
    required this.onPackagingSpecAdded,
    required this.onPackagingSpecRemoved,
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
                  Icons.checklist,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Additional Requirements',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Quality Certifications
            _buildCertificationsSection(context),
            SizedBox(height: 16.h),

            // Packaging Specifications
            _buildPackagingSection(context),
            SizedBox(height: 16.h),

            // Compliance Requirements
            _buildComplianceSection(context),
            SizedBox(height: 16.h),

            // Additional Notes
            TextFormField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Additional Notes',
                hintText: 'Any other requirements or special considerations...',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificationsSection(BuildContext context) {
    final List<String> availableCertifications = [
      'ISO 9001',
      'ISO 14001',
      'FDA Approved',
      'CE Marking',
      'RoHS Compliant',
      'REACH Compliant',
      'UL Listed',
      'NSF Certified',
      'Halal Certified',
      'Kosher Certified',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.verified,
              size: 16.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 8.w),
            Text(
              'Quality Certifications',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),

        // Selected certifications
        if (certifications.isNotEmpty) ...[
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: certifications.map((cert) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified,
                      size: 14.sp,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      cert,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () => onCertificationRemoved(cert),
                      child: Icon(
                        Icons.close,
                        size: 14.sp,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 8.h),
        ],

        // Add certification button
        OutlinedButton.icon(
          onPressed: () =>
              _showCertificationDialog(context, availableCertifications),
          icon: Icon(
            Icons.add,
            size: 16.sp,
          ),
          label: Text(
            'Add Certification',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPackagingSection(BuildContext context) {
    final List<String> availablePackaging = [
      'Palletized',
      'Shrink Wrapped',
      'Moisture Barrier',
      'Temperature Control',
      'Fragile Handling',
      'Vacuum Sealed',
      'Inert Gas Packaging',
      'Anti-Static Packaging',
      'Food Grade Packaging',
      'Hazmat Packaging',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.inventory,
              size: 16.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 8.w),
            Text(
              'Packaging Specifications',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),

        // Selected packaging specs
        if (packagingSpecs.isNotEmpty) ...[
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: packagingSpecs.map((spec) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.inventory,
                      size: 14.sp,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      spec,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () => onPackagingSpecRemoved(spec),
                      child: Icon(
                        Icons.close,
                        size: 14.sp,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 8.h),
        ],

        // Add packaging button
        OutlinedButton.icon(
          onPressed: () => _showPackagingDialog(context, availablePackaging),
          icon: Icon(
            Icons.add,
            size: 16.sp,
          ),
          label: Text(
            'Add Packaging Requirement',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComplianceSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.gavel,
                size: 16.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 8.w),
              Text(
                'Compliance Requirements',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          CheckboxListTile(
            title: Text(
              'Environmental Compliance',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            value: true,
            onChanged: (value) {},
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: Text(
              'Safety Standards Compliance',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            value: true,
            onChanged: (value) {},
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: Text(
              'Industry-Specific Regulations',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            value: false,
            onChanged: (value) {},
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
    );
  }

  void _showCertificationDialog(
      BuildContext context, List<String> availableCertifications) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Certifications',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 300.h,
          child: ListView.builder(
            itemCount: availableCertifications.length,
            itemBuilder: (context, index) {
              final cert = availableCertifications[index];
              final isSelected = certifications.contains(cert);

              return CheckboxListTile(
                title: Text(
                  cert,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: isSelected,
                onChanged: (value) {
                  Navigator.pop(context);
                  if (value == true && !isSelected) {
                    onCertificationAdded(cert);
                  } else if (value == false && isSelected) {
                    onCertificationRemoved(cert);
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPackagingDialog(
      BuildContext context, List<String> availablePackaging) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Packaging Requirements',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 300.h,
          child: ListView.builder(
            itemCount: availablePackaging.length,
            itemBuilder: (context, index) {
              final spec = availablePackaging[index];
              final isSelected = packagingSpecs.contains(spec);

              return CheckboxListTile(
                title: Text(
                  spec,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: isSelected,
                onChanged: (value) {
                  Navigator.pop(context);
                  if (value == true && !isSelected) {
                    onPackagingSpecAdded(spec);
                  } else if (value == false && isSelected) {
                    onPackagingSpecRemoved(spec);
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
