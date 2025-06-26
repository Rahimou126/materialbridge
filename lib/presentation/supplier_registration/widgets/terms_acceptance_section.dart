import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TermsAcceptanceSection extends StatefulWidget {
  final bool termsAccepted;
  final Function(bool) onTermsChanged;

  const TermsAcceptanceSection({
    super.key,
    required this.termsAccepted,
    required this.onTermsChanged,
  });

  @override
  State<TermsAcceptanceSection> createState() => _TermsAcceptanceSectionState();
}

class _TermsAcceptanceSectionState extends State<TermsAcceptanceSection> {
  final bool _showFullTerms = false;

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terms of Service & Privacy Policy'),
        content: SizedBox(
          width: 80.w,
          height: 60.h,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terms of Service',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _getTermsOfService(),
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
                SizedBox(height: 3.h),
                Text(
                  'Privacy Policy',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _getPrivacyPolicy(),
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  String _getTermsOfService() {
    return '''1. ACCEPTANCE OF TERMS
By registering as a supplier on MaterialBridge, you agree to be bound by these Terms of Service and all applicable laws and regulations.

2. SUPPLIER OBLIGATIONS
- Provide accurate and complete business information
- Maintain current certifications and licenses
- Ensure material quality and specifications accuracy
- Respond to purchase requests within 48 hours
- Comply with all applicable industrial regulations

3. MATERIAL LISTINGS
- All material information must be accurate and current
- Technical specifications must be verifiable
- Pricing must be clearly stated with applicable terms
- Availability status must be updated regularly

4. PAYMENT TERMS
- Subscription fees are non-refundable
- Payment processing through Slick Pay API
- Late payment may result in account suspension
- All transactions subject to applicable taxes

5. INTELLECTUAL PROPERTY
- Suppliers retain rights to their material specifications
- MaterialBridge retains rights to platform technology
- No unauthorized use of platform data or content

6. LIMITATION OF LIABILITY
MaterialBridge is not liable for business disputes, material quality issues, or transaction failures between suppliers and factories.

7. TERMINATION
Either party may terminate the agreement with 30 days written notice. Immediate termination for breach of terms.''';
  }

  String _getPrivacyPolicy() {
    return '''1. INFORMATION COLLECTION
We collect business information including company details, contact information, material specifications, and transaction data.

2. USE OF INFORMATION
- Facilitate connections between suppliers and factories
- Process payments and subscriptions
- Improve platform functionality
- Send relevant business notifications

3. INFORMATION SHARING
- Material listings shared with registered factories
- Business contact information shared for legitimate inquiries
- No sharing with third parties without consent
- Compliance with legal requirements when necessary

4. DATA SECURITY
- Industry-standard encryption for sensitive data
- Secure payment processing through certified providers
- Regular security audits and updates
- Access controls and monitoring

5. DATA RETENTION
- Active account data retained during subscription period
- Transaction records retained for 7 years
- Marketing data retained until opt-out
- Right to request data deletion

6. COOKIES AND TRACKING
- Essential cookies for platform functionality
- Analytics cookies for performance improvement
- Marketing cookies with user consent
- Cookie preferences can be managed in settings

7. CONTACT INFORMATION
For privacy concerns, contact: privacy@materialbridge.com''';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Terms & Conditions',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        SizedBox(height: 2.h),

        // Terms Preview
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'gavel',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Legal Agreement',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                'By creating an account, you agree to our Terms of Service and Privacy Policy. Key points include:',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 1.h),
              Text(
                '• Accurate business information and material specifications\n'
                '• Compliance with industrial regulations and standards\n'
                '• Timely response to purchase requests and inquiries\n'
                '• Subscription payment terms and refund policies\n'
                '• Data privacy and information sharing practices',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 2.h),
              GestureDetector(
                onTap: _showTermsDialog,
                child: Text(
                  'Read Full Terms & Privacy Policy',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Acceptance Checkbox
        GestureDetector(
          onTap: () => widget.onTermsChanged(!widget.termsAccepted),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: widget.termsAccepted
                  ? AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.surface,
              border: Border.all(
                color: widget.termsAccepted
                    ? AppTheme.lightTheme.colorScheme.secondary
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                width: widget.termsAccepted ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: widget.termsAccepted
                        ? AppTheme.lightTheme.colorScheme.secondary
                        : Colors.transparent,
                    border: Border.all(
                      color: widget.termsAccepted
                          ? AppTheme.lightTheme.colorScheme.secondary
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: widget.termsAccepted
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.onSecondary,
                          size: 16,
                        )
                      : null,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                      children: [
                        TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: AppTheme.lightTheme.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (!widget.termsAccepted) ...[
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color:
                  AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'You must accept the terms and conditions to create an account',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
