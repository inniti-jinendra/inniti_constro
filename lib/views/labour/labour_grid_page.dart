import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inniti_constro/core/constants/constants.dart';

import '../../core/components/app_back_button.dart';
import '../../core/components/appbar_header.dart';
import '../../core/models/labour/labour_grid_model.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/labour/labour_api_service.dart';

class LabourGridPage extends StatefulWidget {
  const LabourGridPage({super.key});

  @override
  _LabourGridPageState createState() => _LabourGridPageState();
}

class _LabourGridPageState extends State<LabourGridPage> {
  List<LabourGrid> _labourList = [];
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 1;
  final int _pageSize = 15;
  bool _isLoading = false;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _fetchLabours();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _refreshData() async {
    setState(() {
      _labourList = [];
      _currentPage = 1;
      _isLoading = false;
      _hasMoreData = true;
    });

    await _fetchLabours();
  }

  Future<void> _fetchLabours() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newLabours = await LabourApiService.fetchLabours(
        pageNumber: _currentPage,
        pageSize: _pageSize,
      );

      setState(() {
        _labourList.addAll(newLabours);
        _hasMoreData = newLabours.length == _pageSize;
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
      _fetchLabours();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: AppbarHeader(
            headerName: 'Labours', projectName: 'Ganesh Gloary 11'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchLabours,
          ),
        ],
      ),
      body: _labourList.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _labourList.length,
                      itemBuilder: (context, index) {
                        final labour = _labourList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes
                                  .newlabour, // Ensure this route is defined
                              arguments: labour
                                  .labourId, // Pass the labour object or ID
                            );
                          },
                          child: Container(
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
                                _bindListMainHeading(context, labour.firstName,
                                    labour.labourCode),
                                const SizedBox(height: AppDefaults.padding_2),
                                _bindListSecondRow(
                                    context, labour.contractorName),
                                const SizedBox(height: AppDefaults.padding_2),
                                _bindListThirdRow(
                                    context, labour.category, labour.isActive),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.newlabour,
                          arguments: 0);
                    },
                    backgroundColor: AppColors.primary,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
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
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(headerTrailing,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.w500)),
        ),
      ],
    ),
  );
}

Widget _bindListSecondRow(context, rowValue) {
  return Row(
    children: [
      Expanded(
        child: Text(
          rowValue,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.black),
        ),
      )
    ],
  );
}

Widget _bindListThirdRow(context, rowValue, rowTrailing) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(children: [
        FaIcon(FontAwesomeIcons.helmetSafety,
            color: _categoreyColor(rowValue), size: 14),
        const SizedBox(width: AppDefaults.padding_2),
        Text(
          rowValue == '-' ? 'No Categorey Selected' : rowValue,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: _categoreyColor(rowValue)),
        ),
      ]),
      const SizedBox(width: AppDefaults.padding),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: _getStatusColor(rowTrailing).withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          rowTrailing,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _getStatusColor(rowTrailing), fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}

Color _categoreyColor(categorey) {
  if (categorey != '-') {
    return Colors.black;
  }
  return const Color.fromARGB(255, 215, 212, 212);
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'active':
      return Colors.green;
    case 'in-active':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
