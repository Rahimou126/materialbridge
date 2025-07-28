import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/batch_action_widget.dart';
import './widgets/request_card_widget.dart';
import './widgets/requests_filter_widget.dart';

class RequestsManagement extends StatefulWidget {
  const RequestsManagement({super.key});

  @override
  State<RequestsManagement> createState() => _RequestsManagementState();
}

class _RequestsManagementState extends State<RequestsManagement>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String _selectedStatus = 'All';
  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {};
  bool _isLoading = false;
  bool _hasMoreData = true;
  bool _isSelectionMode = false;
  final List<Map<String, dynamic>> _requests = [];
  final Set<String> _selectedRequests = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      final statuses = ['All', 'Pending', 'Quoted', 'Accepted', 'Completed'];
      setState(() {
        _selectedStatus = statuses[_tabController.index];
        _requests.clear();
        _selectedRequests.clear();
        _isSelectionMode = false;
      });
      _loadInitialData();
    }
  }

  void _loadInitialData() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _requests.addAll(_generateMockRequests());
          _isLoading = false;
        });
      }
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
          _requests.addAll(_generateMockRequests());
          _isLoading = false;
          if (_requests.length >= 50) {
            _hasMoreData = false;
          }
        });
      }
    });
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
      builder: (context) => RequestsFilterWidget(
        currentFilters: _activeFilters,
        onApplyFilters: (filters) {
          setState(() {
            _activeFilters = filters;
          });
        },
        onClearFilters: () {
          setState(() {
            _activeFilters.clear();
          });
        },
      ),
    );
  }

  void _onRefresh() {
    setState(() {
      _requests.clear();
      _hasMoreData = true;
    });
    _loadInitialData();
  }

  void _onRequestTap(Map<String, dynamic> request) {
    if (_isSelectionMode) {
      _toggleSelection(request['id']);
    } else {
      _showRequestDetails(request);
    }
  }

  void _onRequestLongPress(Map<String, dynamic> request) {
    setState(() {
      _isSelectionMode = true;
      _selectedRequests.add(request['id']);
    });
  }

  void _toggleSelection(String requestId) {
    setState(() {
      if (_selectedRequests.contains(requestId)) {
        _selectedRequests.remove(requestId);
        if (_selectedRequests.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedRequests.add(requestId);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedRequests.clear();
      _isSelectionMode = false;
    });
  }

  void _showRequestDetails(Map<String, dynamic> request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 8.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.all(16.w),
                  children: [
                    // Request details content
                    _buildRequestDetailsContent(request),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onMessageCustomer(Map<String, dynamic> request) {
    Fluttertoast.showToast(
      msg: "Opening chat with ${request['customerName']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onMarkAsPriority(Map<String, dynamic> request) {
    setState(() {
      request['priority'] = request['priority'] == 'High' ? 'Standard' : 'High';
    });

    Fluttertoast.showToast(
      msg: request['priority'] == 'High'
          ? "Marked as high priority"
          : "Removed from high priority",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onCancelRequest(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Request',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel this request?',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                request['status'] = 'Cancelled';
              });
              Fluttertoast.showToast(
                msg: "Request cancelled",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(
              'Confirm',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _generateMockRequests() {
    final statuses = ['Pending', 'Quoted', 'Accepted', 'Completed'];
    final materials = [
      'Stainless Steel 316L',
      'Polyethylene',
      'Titanium Dioxide',
      'Carbon Fiber'
    ];
    final customers = [
      'ABC Manufacturing',
      'XYZ Industries',
      'Tech Solutions Inc.',
      'Global Materials Co.'
    ];
    final priorities = ['Standard', 'High', 'Urgent'];

    return List.generate(10, (index) {
      final status = statuses[index % statuses.length];
      final material = materials[index % materials.length];
      final customer = customers[index % customers.length];
      final priority = priorities[index % priorities.length];

      return {
        'id': 'REQ${DateTime.now().millisecondsSinceEpoch + index}',
        'materialName': material,
        'customerName': customer,
        'customerEmail':
            'contact@${customer.toLowerCase().replaceAll(' ', '')}.com',
        'customerPhone':
            '+1 (555) ${(100 + index).toString().padLeft(3, '0')}-${(1000 + index).toString().padLeft(4, '0')}',
        'quantity': '${(index + 1) * 100} kg',
        'status': status,
        'priority': priority,
        'submissionDate': DateTime.now().subtract(Duration(days: index + 1)),
        'requiredDate': DateTime.now().add(Duration(days: (index + 1) * 7)),
        'estimatedResponse': _getEstimatedResponse(status),
        'description':
            'High-quality $material required for industrial applications. Detailed specifications provided.',
        'targetPrice': '\$${(50 + index * 10)}-${(80 + index * 10)}/kg',
        'shippingAddress': '123 Industrial Ave, City, State 12345',
        'paymentTerms': 'Net 30',
        'certifications': ['ISO 9001', 'CE Marking'],
        'attachments': ['technical_specs.pdf', 'sample_image.jpg'],
      };
    });
  }

  String _getEstimatedResponse(String status) {
    switch (status) {
      case 'Pending':
        return '2-4 hours';
      case 'Quoted':
        return 'Awaiting customer';
      case 'Accepted':
        return 'Processing';
      case 'Completed':
        return 'Completed';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Requests Management',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              onPressed: _clearSelection,
              icon: Icon(
                Icons.clear,
                size: 24.sp,
              ),
            ),
          ] else ...[
            IconButton(
              onPressed: _onFilterPressed,
              icon: Icon(
                Icons.filter_list,
                size: 24.sp,
              ),
            ),
          ],
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          tabs: [
            Tab(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('All'),
                  _buildStatusBadge(_getStatusCount('All')),
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Pending'),
                  _buildStatusBadge(_getStatusCount('Pending')),
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Quoted'),
                  _buildStatusBadge(_getStatusCount('Quoted')),
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Accepted'),
                  _buildStatusBadge(_getStatusCount('Accepted')),
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Completed'),
                  _buildStatusBadge(_getStatusCount('Completed')),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search requests, materials, or customers...',
                prefixIcon: Icon(
                  Icons.search,
                  size: 20.sp,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                        icon: Icon(
                          Icons.clear,
                          size: 20.sp,
                        ),
                      )
                    : null,
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          // Batch actions bar
          if (_isSelectionMode)
            BatchActionWidget(
              selectedCount: _selectedRequests.length,
              onBatchAction: (action) => _handleBatchAction(action),
            ),

          // Request list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _onRefresh();
              },
              child: _requests.isEmpty && _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _requests.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemCount: _requests.length + (_hasMoreData ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _requests.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final request = _requests[index];
                            final isSelected =
                                _selectedRequests.contains(request['id']);

                            return RequestCardWidget(
                              request: request,
                              isSelected: isSelected,
                              isSelectionMode: _isSelectionMode,
                              onTap: () => _onRequestTap(request),
                              onLongPress: () => _onRequestLongPress(request),
                              onMessageCustomer: () =>
                                  _onMessageCustomer(request),
                              onMarkAsPriority: () =>
                                  _onMarkAsPriority(request),
                              onCancelRequest: () => _onCancelRequest(request),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.purchaseRequestForm);
        },
        child: Icon(
          Icons.add,
          size: 24.sp,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        count.toString(),
        style: GoogleFonts.inter(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  int _getStatusCount(String status) {
    if (status == 'All') return _requests.length;
    return _requests.where((request) => request['status'] == status).length;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 64.sp,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 16.h),
          Text(
            'No requests found',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'New purchase requests will appear here',
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

  Widget _buildRequestDetailsContent(Map<String, dynamic> request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          request['materialName'] ?? 'Unknown Material',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            _buildStatusChip(request['status']),
            SizedBox(width: 8.w),
            _buildPriorityChip(request['priority']),
          ],
        ),
        SizedBox(height: 16.h),

        // Customer information
        _buildDetailSection('Customer Information', [
          _buildDetailRow('Name', request['customerName']),
          _buildDetailRow('Email', request['customerEmail']),
          _buildDetailRow('Phone', request['customerPhone']),
        ]),

        // Order details
        _buildDetailSection('Order Details', [
          _buildDetailRow('Quantity', request['quantity']),
          _buildDetailRow('Target Price', request['targetPrice']),
          _buildDetailRow(
              'Required Date', _formatDate(request['requiredDate'])),
          _buildDetailRow('Payment Terms', request['paymentTerms']),
        ]),

        // Description
        _buildDetailSection('Description', [
          Text(
            request['description'] ?? 'No description provided',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ]),

        // Action buttons
        SizedBox(height: 24.h),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _onMessageCustomer(request),
                icon: Icon(
                  Icons.message,
                  size: 16.sp,
                ),
                label: Text(
                  'Message Customer',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Handle send quote
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: "Quote feature coming soon",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                },
                icon: Icon(
                  Icons.send,
                  size: 16.sp,
                ),
                label: Text(
                  'Send Quote',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        ...children,
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              '$label:',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Pending':
        color = Colors.orange;
        break;
      case 'Quoted':
        color = Colors.blue;
        break;
      case 'Accepted':
        color = Colors.green;
        break;
      case 'Completed':
        color = Colors.grey;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color color;
    switch (priority) {
      case 'High':
        color = Colors.red;
        break;
      case 'Urgent':
        color = Colors.deepOrange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        priority,
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _handleBatchAction(String action) {
    switch (action) {
      case 'mark_priority':
        // Mark selected requests as priority
        for (final requestId in _selectedRequests) {
          final request = _requests.firstWhere((r) => r['id'] == requestId);
          request['priority'] = 'High';
        }
        break;
      case 'send_quote':
        // Send quotes for selected requests
        Fluttertoast.showToast(
          msg: "Quote feature coming soon",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        break;
      case 'delete':
        // Delete selected requests
        _requests.removeWhere(
            (request) => _selectedRequests.contains(request['id']));
        break;
    }

    setState(() {
      _selectedRequests.clear();
      _isSelectionMode = false;
    });
  }
}
