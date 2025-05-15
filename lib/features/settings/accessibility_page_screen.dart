import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/font_styles.dart';
import '../../core/models/settings/Accessibility_model.dart';
import '../../core/services/settings/Accessibility.dart';

class AccessibilityPageScreen extends StatefulWidget {
  const AccessibilityPageScreen({super.key});

  @override
  State<AccessibilityPageScreen> createState() => _AccessibilityPageScreenState();
}

class _AccessibilityPageScreenState extends State<AccessibilityPageScreen> {
  late Future<List<AccessibilityItem>> accessibilityListFuture;
  List<AccessibilityItem> accessibilityItems = [];

  String selectedUser = 'Dishant Babariya';
  String selectedRole = 'Site Supervisor';

  @override
  void initState() {
    super.initState();
    fetchAccessibilityData();
  }

  Future<void> fetchAccessibilityData() async {
    accessibilityListFuture = fetchAccessibilityList();
    accessibilityItems = await accessibilityListFuture;
    setState(() {});
  }

  Future<void> toggleAccessibility(int index, bool value) async {
    final item = accessibilityItems[index];

    final success = await addAccessibilityItem(
      appMenuID: item.appMenuID,
      isAccessible: value,
    );

    if (success) {
      setState(() {
        accessibilityItems[index] = item.copyWith(isAccessible: value);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update ${item.menuName}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context, true),
              icon: SvgPicture.asset("assets/icons/setting/LeftArrow.svg"),
              color: AppColors.primaryBlue,
            ),
            title: Text(
              'Accessibility',
              style: FontStyles.bold700.copyWith(
                color: AppColors.primaryBlackFont,
                fontSize: 20,
              ),
            ),
            backgroundColor: AppColors.primaryWhitebg,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCard(
              icon: Icons.person,
              title: 'Search By Users',
              subtitle: selectedUser,
              onTap: () => _showBottomSheet(
                context,
                'Select User',
                [
                  'Dishant Babariya',
                  'Rahul Patel',
                  'Megha Shah',
                  'Amit Gupta',
                ],
                    (value) {
                  setState(() {
                    selectedUser = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            _buildCard(
              icon: Icons.group,
              title: 'App Role',
              subtitle: selectedRole,
              onTap: () => _showBottomSheet(
                context,
                'Select App Role',
                [
                  'Site Supervisor',
                  'Project Manager',
                  'Admin',
                  'Field Engineer',
                ],
                    (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F5FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FontStyles.semiBold600.copyWith(
                      fontSize: 12,
                      color: AppColors.primaryLightGrayFont,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          subtitle,
                          style: FontStyles.bold700.copyWith(
                            fontSize: 16,
                            color: AppColors.primaryBlackFont,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down_sharp, color: AppColors.primary),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(
      BuildContext context,
      String title,
      List<String> items,
      Function(String) onItemSelected,
      ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: FontStyles.bold700.copyWith(
                  fontSize: 18,
                  color: AppColors.primaryBlackFont,
                ),
              ),
              const SizedBox(height: 12),
              ...items.map((item) {
                return ListTile(
                  title: Text(
                    item,
                    style: FontStyles.regular400.copyWith(
                      color: AppColors.primaryBlackFont,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onItemSelected(item);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
