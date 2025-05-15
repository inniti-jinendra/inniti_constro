import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/font_styles.dart';
import '../../core/models/settings/Accessibility_model.dart';
import '../../core/services/settings/Accessibility.dart';

class MenuAccessibilityPageScreen extends StatefulWidget {
  const MenuAccessibilityPageScreen({super.key});

  @override
  State<MenuAccessibilityPageScreen> createState() => _MenuAccessibilityPageScreenState();
}

class _MenuAccessibilityPageScreenState extends State<MenuAccessibilityPageScreen> {
  late Future<List<AccessibilityItem>> accessibilityListFuture;
  List<AccessibilityItem> accessibilityItems = [];

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
              'Menu Accessibility',
              style: FontStyles.bold700.copyWith(
                color: AppColors.primaryBlackFont,
                fontSize: 18,
              ),
            ),
            backgroundColor: AppColors.primaryWhitebg,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: accessibilityItems.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: accessibilityItems.length,
          itemBuilder: (context, index) {
            final item = accessibilityItems[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x405B21B1),
                      offset: const Offset(0, 0),
                      blurRadius: 14,
                      spreadRadius: -6,
                    ),
                  ],
                ),
                child: Center(
                  child: ListTile(
                    leading: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primaryWhitebg, // Optional: Set a background color if needed
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          "assets/icons/setting/LeftArrow.svg",
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                    title: Text(item.menuName),
                    trailing: Container(
                      width: 38,
                      height: 23,
                      child: GestureDetector(
                        onTap: () => toggleAccessibility(index, !item.isAccessible), // Toggle value on tap
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 250),
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: item.isAccessible ? Color(0xff96e9b7) : Color(0xffdb8484),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: AnimatedAlign(
                            duration: Duration(milliseconds: 250),
                            alignment: item.isAccessible ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: item.isAccessible ? Color(0xff2DD36F) : Color(0xffB70909),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                item.isAccessible ? 'A' : 'D',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
