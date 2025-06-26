import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/material_preview_card_widget.dart';
import './widgets/metrics_card_widget.dart';
import './widgets/quick_action_button_widget.dart';
import './widgets/recent_request_card_widget.dart';

class SupplierDashboard extends StatefulWidget {
  const SupplierDashboard({super.key});

  @override
  State<SupplierDashboard> createState() => _SupplierDashboardState();
}

class _SupplierDashboardState extends State<SupplierDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;

  // Mock data for supplier dashboard
  final Map<String, dynamic> supplierData = {
    "name": "Industrial Materials Co.",
    "subscriptionStatus": "Premium",
    "notificationCount": 5,
    "metrics": {
      "activeListings": 24,
      "pendingRequests": 8,
      "monthlyInquiries": 156,
      "revenue": "\$45,230"
    }
  };

  final List<Map<String, dynamic>> recentRequests = [
    {
      "id": 1,
      "buyerCompany": "TechManufacturing Ltd",
      "materialRequested": "High-Grade Steel Alloy",
      "quantity": "500 tons",
      "requiredDate": "2024-02-15",
      "status": "pending",
      "priority": "high"
    },
    {
      "id": 2,
      "buyerCompany": "AutoParts Industries",
      "materialRequested": "Aluminum Sheets",
      "quantity": "200 sheets",
      "requiredDate": "2024-02-20",
      "status": "pending",
      "priority": "medium"
    },
    {
      "id": 3,
      "buyerCompany": "Construction Dynamics",
      "materialRequested": "Reinforced Concrete Mix",
      "quantity": "1000 bags",
      "requiredDate": "2024-02-18",
      "status": "pending",
      "priority": "high"
    }
  ];

  final List<Map<String, dynamic>> topMaterials = [
    {
      "id": 1,
      "name": "Premium Steel Rods",
      "image":
          "https://images.pexels.com/photos/162553/keys-workshop-mechanic-tools-162553.jpeg",
      "inquiryCount": 23,
      "category": "Metals"
    },
    {
      "id": 2,
      "name": "Industrial Plastic Sheets",
      "image":
          "https://images.pixabay.com/photo/2016/11/29/12/13/plastic-1869403_1280.jpg",
      "inquiryCount": 18,
      "category": "Plastics"
    },
    {
      "id": 3,
      "name": "Chemical Compounds",
      "image": "https://images.unsplash.com/photo-1532187863486-abf9dbad1b69",
      "inquiryCount": 15,
      "category": "Chemicals"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDashboardTab(),
                  _buildMaterialsTab(),
                  _buildRequestsTab(),
                  _buildProfileTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          _tabController.index == 0 ? _buildFloatingActionButton() : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  supplierData["name"] as String,
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${supplierData["subscriptionStatus"]} Member",
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: CustomIconWidget(
                  iconName: 'notifications',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
              if ((supplierData["notificationCount"] as int) > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(0.5.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 4.w,
                      minHeight: 4.w,
                    ),
                    child: Text(
                      '${supplierData["notificationCount"]}',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onError,
                        fontSize: 10.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Dashboard'),
          Tab(text: 'Materials'),
          Tab(text: 'Requests'),
          Tab(text: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricsSection(),
            SizedBox(height: 3.h),
            _buildRecentRequestsSection(),
            SizedBox(height: 3.h),
            _buildMaterialsPreviewSection(),
            SizedBox(height: 3.h),
            _buildQuickActionsSection(),
            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialsTab() {
    return Center(
      child: Text(
        'Materials Management',
        style: AppTheme.lightTheme.textTheme.titleLarge,
      ),
    );
  }

  Widget _buildRequestsTab() {
    return Center(
      child: Text(
        'Purchase Requests',
        style: AppTheme.lightTheme.textTheme.titleLarge,
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Text(
        'Supplier Profile',
        style: AppTheme.lightTheme.textTheme.titleLarge,
      ),
    );
  }

  Widget _buildMetricsSection() {
    final metrics = supplierData["metrics"] as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Overview',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 2.h,
          childAspectRatio: 1.5,
          children: [
            MetricsCardWidget(
              title: 'Active Listings',
              value: '${metrics["activeListings"]}',
              icon: 'inventory',
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            MetricsCardWidget(
              title: 'Pending Requests',
              value: '${metrics["pendingRequests"]}',
              icon: 'pending_actions',
              color: AppTheme.lightTheme.colorScheme.tertiary,
            ),
            MetricsCardWidget(
              title: 'Monthly Inquiries',
              value: '${metrics["monthlyInquiries"]}',
              icon: 'trending_up',
              color: AppTheme.lightTheme.colorScheme.secondary,
            ),
            MetricsCardWidget(
              title: 'Revenue',
              value: metrics["revenue"] as String,
              icon: 'attach_money',
              color: Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Requests',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                _tabController.animateTo(2);
              },
              child: Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 20.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recentRequests.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              return RecentRequestCardWidget(
                request: recentRequests[index],
                onAccept: () =>
                    _handleRequestAction('accept', recentRequests[index]),
                onDecline: () =>
                    _handleRequestAction('decline', recentRequests[index]),
                onMessage: () =>
                    _handleRequestAction('message', recentRequests[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialsPreviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top Performing Materials',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                _tabController.animateTo(1);
              },
              child: Text('Manage All'),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: topMaterials.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemBuilder: (context, index) {
            return MaterialPreviewCardWidget(
              material: topMaterials[index],
              onTap: () => _handleMaterialTap(topMaterials[index]),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: QuickActionButtonWidget(
                title: 'Add Material',
                icon: 'add_circle',
                color: AppTheme.lightTheme.colorScheme.primary,
                onTap: () =>
                    Navigator.pushNamed(context, '/material-listing-creation'),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: QuickActionButtonWidget(
                title: 'Analytics',
                icon: 'analytics',
                color: AppTheme.lightTheme.colorScheme.secondary,
                onTap: () => _handleAnalyticsTap(),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          child: QuickActionButtonWidget(
            title: 'Manage Subscription',
            icon: 'card_membership',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            onTap: () => _handleSubscriptionTap(),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () =>
          Navigator.pushNamed(context, '/material-listing-creation'),
      child: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 24,
      ),
    );
  }

  void _handleRequestAction(String action, Map<String, dynamic> request) {
    String message = '';
    switch (action) {
      case 'accept':
        message = 'Request accepted for ${request["materialRequested"]}';
        break;
      case 'decline':
        message = 'Request declined for ${request["materialRequested"]}';
        break;
      case 'message':
        message = 'Opening chat with ${request["buyerCompany"]}';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleMaterialTap(Map<String, dynamic> material) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${material["name"]} details'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleAnalyticsTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening analytics dashboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleSubscriptionTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening subscription management'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
