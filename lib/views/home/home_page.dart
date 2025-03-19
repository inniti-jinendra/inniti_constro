import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inniti_constro/core/constants/app_colors.dart';
import 'package:inniti_constro/views/home/components/ERP_assigned_tasks_detailes.dart';
import 'package:inniti_constro/views/home/components/ERP_dashboard_lead_project_details.dart';
import 'package:inniti_constro/views/home/components/ERP_project_progress_bar_chart.dart';
import '../../core/constants/app_icons.dart';

import '../../core/constants/app_defaults.dart';
import '../../core/routes/app_routes.dart';
import 'components/ERP_project_progress_pie_chart.dart';
import 'components/ad_space.dart';
import 'components/our_new_item.dart';
import 'components/popular_packs.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.drawerPage);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2F6F3),
                    shape: const CircleBorder(),
                  ),
                  child: SvgPicture.asset(AppIcons.sidebarIcon),
                ),
              ),
              floating: true,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: AppDefaults.padding,
                children: [
                  Image.asset(
                    "assets/images/inniti_logo.png",
                    height: 32,
                  )
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.search);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF2F6F3),
                      shape: const CircleBorder(),
                    ),
                    child: SvgPicture.asset(AppIcons.search),
                  ),
                ),
              ],
            ),
            const SliverToBoxAdapter(
              child: ErpDashboardLeadProjectDetails(),
            ),
            const SliverToBoxAdapter(
              child: ErpAssignedTasksDetailes(),
            ),
            const SliverToBoxAdapter(
              child: ErpProjectProgressPieChart(),
            ),
            const SliverToBoxAdapter(
              child: ErpProjectProgressBarChart(),
            ),
            const SliverToBoxAdapter(
              child: AdSpace(),
            ),
            const SliverToBoxAdapter(
              child: PopularPacks(),
            ),
            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: AppDefaults.padding),
              sliver: SliverToBoxAdapter(
                child: OurNewItem(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
