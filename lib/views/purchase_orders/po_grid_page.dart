import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inniti_constro/core/constants/constants.dart';

import '../../core/components/app_back_button.dart';
import '../../core/components/appbar_header.dart';
import '../../core/models/purchase_orders/po_grid_model.dart';
import '../../core/services/purchase_orders/po_api_service.dart';

class PoGridPage extends StatefulWidget {
  const PoGridPage({super.key});

  @override
  _PoGridPageState createState() => _PoGridPageState();
}

class _PoGridPageState extends State<PoGridPage> {
  List<PoGrid> _poList = []; // List of purchase orders
  Map<int, List<POGridItems>> poItems = {}; // Store items by PO ID
  Set<int> expandedPOs = {}; // Track expanded POs
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 1;
  final int _pageSize = 15;
  bool _isLoading = false;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _poList = [];
    _currentPage = 1;
    _isLoading = false;
    _hasMoreData = true;
    _fetchPurchaseOrders(); // Fetch PO list
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _fetchPurchaseOrders();
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _poList = [];
      _currentPage = 1;
      _isLoading = false;
      _hasMoreData = true;
    });

    await _fetchPurchaseOrders();
  }

  Future<void> _fetchPurchaseOrders() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newPR = await PoApiService.fetchPoGrid(
        pageNumber: _currentPage,
        pageSize: _pageSize,
      );

      setState(() {
        _poList.addAll(newPR);
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

  Future<void> _fetchPOItems(int poId) async {
    if (poItems.containsKey(poId))
      return; // Don't fetch again if already loaded

    await Future.delayed(const Duration(seconds: 1));

    // Await the future to get the actual list of POGridItems
    final poitems = await PoApiService.fetchPoItemsGrid(purchaseOrderID: poId);

    setState(() {
      // Now poitems is a List<POGridItems> and can be directly assigned to poItems
      poItems[poId] = poitems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: AppbarHeader(
            headerName: 'Purchase Orders', projectName: 'Ganesh Gloary 11'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchPurchaseOrders,
          ),
        ],
      ),
      body: _poList.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _poList.length,
                  itemBuilder: (context, index) {
                    final po = _poList[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: AppDefaults.padding,
                          vertical: AppDefaults.padding_2),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: AppDefaults.boxShadow),
                      child: ExpansionTile(
                        title: Column(
                          children: [
                            SingleChildScrollView(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    po.poNumber,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(po.status)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(po.status,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                                color:
                                                    getStatusColor(po.status),
                                                fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppDefaults.padding_2),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    po.supplierName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: AppDefaults.padding_2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  const FaIcon(
                                      FontAwesomeIcons
                                          .calendar, // Change icon as needed
                                      color: AppColors.primary,
                                      size: 14),
                                  const SizedBox(width: AppDefaults.padding_2),
                                  Text(
                                    po.orderDate,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ]),
                                const SizedBox(width: AppDefaults.padding),
                                Text(
                                  po.totalAmount,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppDefaults.padding_2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(80,
                                        20), // Set the button size (width, height)
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 10), // Adjust padding
                                  ),
                                  child: Row(
                                    children: [
                                      const FaIcon(
                                          FontAwesomeIcons
                                              .penToSquare, // Change icon as needed
                                          color: AppColors.primary,
                                          size: 14),
                                      const SizedBox(
                                          width: AppDefaults.padding_2),
                                      Text("Details",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(color: Colors.black)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: AppDefaults.padding_2),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(80,
                                        20), // Set the button size (width, height)
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 10), // Adjust padding
                                  ),
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      const FaIcon(
                                          FontAwesomeIcons
                                              .trashCan, // Change icon as needed
                                          color: AppColors.primary,
                                          size: 14),
                                      const SizedBox(
                                          width: AppDefaults.padding_2),
                                      Text("Delete",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onExpansionChanged: (isExpanded) {
                          if (isExpanded) {
                            _fetchPOItems(po.poId);
                          }
                          setState(() {
                            if (isExpanded) {
                              expandedPOs.add(po.poId);
                            } else {
                              expandedPOs.remove(po.poId);
                            }
                          });
                        },
                        children: poItems[po.poId]
                                ?.map((item) => buildItemTile(context, item))
                                .toList() ??
                            [const CircularProgressIndicator()],
                      ),
                    );
                  }),
            ),
    );
  }
}

Widget buildItemTile(context, POGridItems item) {
  return Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: AppDefaults.padding, vertical: 5),
    child: Column(
      children: [
        Row(
          children: [
            const FaIcon(FontAwesomeIcons.cubes, // Change icon as needed
                color: AppColors.primary,
                size: 12),
            const SizedBox(width: AppDefaults.padding_2),
            Text(item.itemName,
                style: Theme.of(context).textTheme.labelSmall?.copyWith()),
          ],
        ),
        const SizedBox(height: AppDefaults.padding_2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const FaIcon(
                    FontAwesomeIcons.cartArrowDown, // Change icon as needed
                    color: AppColors.primary,
                    size: 12),
                const SizedBox(width: AppDefaults.padding_2),
                Text("Order: ${item.orderQuantity}",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith()),
              ],
            ),
            Row(
              children: [
                const FaIcon(
                    FontAwesomeIcons.hourglassHalf, // Change icon as needed
                    color: AppColors.primary,
                    size: 12),
                const SizedBox(width: AppDefaults.padding_2),
                Text("Pending: ${item.pendingQuantity}",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith()),
              ],
            ),
          ],
        )
      ],
    ),
  );
}

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'rejected':
      return Colors.orange;
    case 'approved':
      return Colors.green;
    case 'received':
      return Colors.greenAccent;
    case 'closed':
      return Colors.red;
    case 'completed':
      return Colors.blue;
    case 'draft':
      return Colors.yellow;
    default:
      return Colors.grey;
  }
}
