import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentTermsWidget extends StatelessWidget {
  final String selectedPaymentTerms;
  final TextEditingController customTermsController;
  final Function(String) onPaymentTermsChanged;

  const PaymentTermsWidget({
    super.key,
    required this.selectedPaymentTerms,
    required this.customTermsController,
    required this.onPaymentTermsChanged,
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
                  Icons.payment,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Payment Terms',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Payment terms dropdown
            DropdownButtonFormField<String>(
              value: selectedPaymentTerms,
              decoration: const InputDecoration(
                labelText: 'Payment Terms',
                hintText: 'Select payment terms',
              ),
              items: const [
                DropdownMenuItem(value: 'Net 15', child: Text('Net 15 days')),
                DropdownMenuItem(value: 'Net 30', child: Text('Net 30 days')),
                DropdownMenuItem(value: 'Net 45', child: Text('Net 45 days')),
                DropdownMenuItem(value: 'Net 60', child: Text('Net 60 days')),
                DropdownMenuItem(value: 'COD', child: Text('Cash on Delivery')),
                DropdownMenuItem(
                    value: 'Prepaid', child: Text('Prepayment Required')),
                DropdownMenuItem(
                    value: '2/10 Net 30', child: Text('2/10 Net 30')),
                DropdownMenuItem(
                    value: '1/15 Net 30', child: Text('1/15 Net 30')),
                DropdownMenuItem(
                    value: 'Letter of Credit', child: Text('Letter of Credit')),
                DropdownMenuItem(value: 'Custom', child: Text('Custom Terms')),
              ],
              onChanged: (value) {
                if (value != null) {
                  onPaymentTermsChanged(value);
                }
              },
            ),
            SizedBox(height: 16.h),

            // Custom terms field (shown only when "Custom" is selected)
            if (selectedPaymentTerms == 'Custom') ...[
              TextFormField(
                controller: customTermsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Custom Payment Terms',
                  hintText: 'Describe your preferred payment terms',
                ),
                validator: (value) {
                  if (selectedPaymentTerms == 'Custom' &&
                      (value == null || value.isEmpty)) {
                    return 'Please specify custom payment terms';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
            ],

            // Payment terms explanations
            _buildPaymentTermsInfo(context),

            SizedBox(height: 16.h),

            // Additional payment options
            _buildAdditionalPaymentOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTermsInfo(BuildContext context) {
    String description = '';
    Color bgColor = Theme.of(context).colorScheme.surfaceContainerHighest;

    switch (selectedPaymentTerms) {
      case 'Net 15':
        description = 'Payment is due within 15 days of invoice date';
        break;
      case 'Net 30':
        description = 'Payment is due within 30 days of invoice date';
        break;
      case 'Net 45':
        description = 'Payment is due within 45 days of invoice date';
        break;
      case 'Net 60':
        description = 'Payment is due within 60 days of invoice date';
        break;
      case 'COD':
        description = 'Payment is due upon delivery of goods';
        bgColor = Theme.of(context).colorScheme.primaryContainer;
        break;
      case 'Prepaid':
        description = 'Payment is required before goods are shipped';
        bgColor = Theme.of(context).colorScheme.primaryContainer;
        break;
      case '2/10 Net 30':
        description =
            '2% discount if paid within 10 days, otherwise due in 30 days';
        bgColor = Theme.of(context).colorScheme.tertiaryContainer;
        break;
      case '1/15 Net 30':
        description =
            '1% discount if paid within 15 days, otherwise due in 30 days';
        bgColor = Theme.of(context).colorScheme.tertiaryContainer;
        break;
      case 'Letter of Credit':
        description = 'Payment secured by letter of credit from bank';
        break;
      case 'Custom':
        description = 'Please specify your custom payment terms above';
        break;
    }

    if (description.isNotEmpty) {
      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline,
              size: 16.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildAdditionalPaymentOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Payment Information',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.h),

        // Payment methods
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _buildPaymentMethodChip(
                context, 'Wire Transfer', Icons.account_balance),
            _buildPaymentMethodChip(context, 'ACH', Icons.credit_card),
            _buildPaymentMethodChip(context, 'Check', Icons.receipt),
            _buildPaymentMethodChip(context, 'Credit Card', Icons.credit_card),
          ],
        ),

        SizedBox(height: 16.h),

        // Payment security info
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.security,
                    size: 16.sp,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Secure Payment Processing',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'All payments are processed through secure, encrypted channels. Your financial information is protected.',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodChip(
      BuildContext context, String method, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          SizedBox(width: 4.w),
          Text(
            method,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
