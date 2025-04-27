import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/components/app_back_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/models/profile/item_assigned_details.dart';
import '../../../core/services/system/system_api_service.dart';



class AssignedItemsPage extends StatefulWidget {
  const AssignedItemsPage({super.key});

  @override
  State<AssignedItemsPage> createState() => _AssignedItemsPageState();
}

class _AssignedItemsPageState extends State<AssignedItemsPage> {
  List<ItemAssignedDetails>? _itemAssignedDetails;

  @override
  void initState() {
    super.initState();
    _fatchUserDetailsItemAssignedByUserID(); // Fetch user details if not already fetched
  }

  Future<void> _fatchUserDetailsItemAssignedByUserID() async {
    try {
      final itemAssignedDetails =
          await SystemApiService.fatchUserDetailsItemAssignedByUserID();
      setState(() {
        _itemAssignedDetails = itemAssignedDetails;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load user details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text(
          'Assign Items',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fatchUserDetailsItemAssignedByUserID,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemCount: _itemAssignedDetails?.length ?? 0,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: AppDefaults.boxShadow),
                    child: Padding(
                      padding: const EdgeInsets.all(AppDefaults.padding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const FaIcon(
                                        FontAwesomeIcons
                                            .box, // Change icon as needed
                                        color: AppColors.primary,
                                        size: 12),
                                    const SizedBox(
                                        width: AppDefaults.padding_2),
                                    Text(
                                        _itemAssignedDetails?[index].itemName ??
                                            "Loading...",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold))
                                  ],
                                ),
                                const SizedBox(height: AppDefaults.padding_2),
                                Text(
                                    _itemAssignedDetails?[index].brandName ??
                                        "Loading...",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: Colors.black))
                              ]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                      _itemAssignedDetails?[index].qty ??
                                          "Loading...",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500)),
                                ),
                                const SizedBox(height: AppDefaults.padding_2),
                                Row(
                                  children: [
                                    const FaIcon(
                                        FontAwesomeIcons
                                            .calendar, // Change icon as needed
                                        color: AppColors.primary,
                                        size: 12),
                                    const SizedBox(
                                        width: AppDefaults.padding_2),
                                    Text(
                                        _itemAssignedDetails?[index]
                                                .assignedDate ??
                                            "Loading...",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(color: Colors.black)),
                                  ],
                                ),
                              ]),
                        ],
                      ),
                    ),
                  );
                  // return Card(
                  //   elevation: 2,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   margin: const EdgeInsets.symmetric(vertical: 10),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(12.0), // Reduced padding
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Expanded(
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 _itemAssignedDetails?[index].itemName ??
                  //                     "Loading...",
                  //                 style: TextStyle(
                  //                   fontSize: 18, // Reduced font size
                  //                   fontWeight: FontWeight
                  //                       .w500, // Changed to a lighter weight
                  //                   color: Colors.teal[800],
                  //                 ),
                  //               ),
                  //               const SizedBox(height: 4),
                  //               Row(
                  //                 children: [
                  //                   Icon(Icons.calendar_today,
                  //                       size: 14, color: Colors.teal[600]),
                  //                   const SizedBox(width: 4),
                  //                   Text(
                  //                     'Assigned on: ${_itemAssignedDetails?[index].assignedDate ?? "Loading..."}',
                  //                     style: TextStyle(
                  //                       fontSize: 12, // Reduced font size
                  //                       color: Colors.teal[500],
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         // Quantity displayed in trailing
                  //         Text(
                  //           'Qty: ${_itemAssignedDetails?[index].qty ?? "Loading..."}',
                  //           style: TextStyle(
                  //             fontSize: 14, // Reduced font size
                  //             fontWeight: FontWeight
                  //                 .w500, // Changed to a lighter weight
                  //             color: Colors.teal[800],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
