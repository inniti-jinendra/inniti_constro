import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/constants.dart';
import '../../core/models/purchase_requisition/pr_grid_model.dart';

import '../../core/services/purchase_requisition/pr_api_service.dart';
import '../../routes/app_routes.dart';

class PrGridPage extends StatefulWidget {
  const PrGridPage({super.key});

  @override
  _PoGridPageState createState() => _PoGridPageState();
}

class _PoGridPageState extends State<PrGridPage> {
  List<PrGrid> _prList = [];
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 1;
  final int _pageSize = 15;
  bool _isLoading = false;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _fetchPR();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _refreshData() async {
    setState(() {
      _prList = [];
      _currentPage = 1;
      _isLoading = false;
      _hasMoreData = true;
    });

    await _fetchPR();
  }

  Future<void> _fetchPR() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newPR = await PrApiService.fetchPRGrid(
        pageNumber: _currentPage,
        pageSize: _pageSize,
        itemName: "",
        requestedBy: "",
        requisitionDate: "",
        requisitionNumber: "",
        status: "",
      );

      setState(() {
        _prList.addAll(newPR);
        _hasMoreData = newPR.length == _pageSize;
        if (_hasMoreData) _currentPage++;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _fetchPR();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: const AppBackButton(),
        title: Text(
          'Purchase Requisition',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchPR,
          ),
        ],
      ),
      body: _prList.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _prList.length,
                      itemBuilder: (context, index) {
                        final pr = _prList[index];
                        return Container(
                          padding: const EdgeInsets.all(AppDefaults.padding),
                          margin: const EdgeInsets.symmetric(
                              horizontal: AppDefaults.padding,
                              vertical: AppDefaults.padding_2),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: AppDefaults.boxShadow),
                          child: Column(
                            children: [
                              _bindListMainHeading(
                                  context, pr.requisitionNo, pr.status),
                              const SizedBox(height: AppDefaults.padding_2),
                              _bindListSecondRow(context, pr.requisitionDate),
                            ],
                          ),
                        );
                      }),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.newPR);
                    },
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
    );
  }
}

Widget _bindListMainHeading(context, headingTitle, headerTrailing) {
  return SingleChildScrollView(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          headingTitle,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: _getStatusColor(headerTrailing).withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(headerTrailing,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: _getStatusColor(headerTrailing),
                  fontWeight: FontWeight.w500)),
        ),
      ],
    ),
  );
}

Widget _bindListSecondRow(context, rowValue) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(children: [
        const FaIcon(FontAwesomeIcons.calendar,
            color: AppColors.primary, size: 14),
        const SizedBox(width: AppDefaults.padding_2),
        Text(
          rowValue,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ]),
    ],
  );
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'approved':
      return Colors.green;
    case 'pending':
      return Colors.orange;
    case 'rejected':
      return Colors.red;
    case 'draft':
      return Colors.deepOrangeAccent;
    default:
      return Colors.grey;
  }
}
