import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inniti_constro/core/constants/app_colors.dart';
import 'package:inniti_constro/core/network/logger.dart';
import '../../../../core/constants/font_styles.dart';

class PettyCashPage extends StatefulWidget {
  const PettyCashPage({super.key});

  @override
  _PettyCashPageState createState() => _PettyCashPageState();
}

class _PettyCashPageState extends State<PettyCashPage> {
  int _selectedIndex = 0; // This will track the selected month index

  // Dummy data for each month
  final Map<String, List<Map<String, String>>> monthData = {
    "Jan": [
      {"tds": "1000", "date": "01/01/2024"},
      {"tds": "1500", "date": "15/01/2024"},
      {"tds": "2200", "date": "20/01/2024"},
      {"tds": "1800", "date": "25/01/2024"},
    ],
    "Feb": [
      {"tds": "1200", "date": "05/02/2024"},
      {"tds": "3000", "date": "15/02/2024"},
      {"tds": "3000", "date": "15/02/2024"},
      {"tds": "2500", "date": "18/02/2024"},
      {"tds": "2100", "date": "22/02/2024"},
      {"tds": "2700", "date": "28/02/2024"},
    ],
    "Mar": [
      {"tds": "1500", "date": "01/03/2024"},
      {"tds": "2500", "date": "20/03/2024"},
      {"tds": "2300", "date": "25/03/2024"},
    ],
    "Apr": [
      {"tds": "1100", "date": "12/04/2024"},
      {"tds": "2700", "date": "25/04/2024"},
      {"tds": "1900", "date": "05/04/2024"},
      {"tds": "2200", "date": "15/04/2024"},
      {"tds": "2200", "date": "15/04/2024"},
      {"tds": "2200", "date": "15/04/2024"},
      {"tds": "2400", "date": "20/04/2024"},
    ],
    "May": [
      {"tds": "1800", "date": "02/05/2024"},
      {"tds": "2300", "date": "18/05/2024"},
      {"tds": "2500", "date": "10/05/2024"},
      {"tds": "2700", "date": "25/05/2024"},
    ],
    "Jun": [
      {"tds": "1400", "date": "10/06/2024"},
      {"tds": "2200", "date": "22/06/2024"},
      {"tds": "1900", "date": "05/06/2024"},
      {"tds": "1900", "date": "05/06/2024"},
      {"tds": "1900", "date": "05/06/2024"},
      {"tds": "2500", "date": "15/06/2024"},
      {"tds": "2000", "date": "30/06/2024"},
    ],
    "Jul": [
      {"tds": "1600", "date": "01/07/2024"},
      {"tds": "2100", "date": "15/07/2024"},
      {"tds": "1800", "date": "25/07/2024"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(
            "assets/icons/setting/LeftArrow.svg",
          ),
          color: AppColors.primaryBlue,
        ),
        title: Text(
          'Bhakti Petty Cash',
          style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppColors.primaryBlackFont,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
              icon: Icon(Icons.filter_list_alt, color: AppColors.primaryBlue),
              onPressed: () {
                // Implement your filter functionality here
              },
            ),
          ),
        ],
        backgroundColor: AppColors.primaryWhitebg,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildBalanceCard(),
              const SizedBox(height: 10),
              _buildMonthChips(),
              const SizedBox(height: 10),
              _buildTdsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryWhitebg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/Petty-Cash-ICON-SVG.svg',
                  height: 16,
                  width: 16,
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Available Balance",
                  style: GoogleFonts.nunitoSans(fontSize: 10),
                ),
                Text(
                  "50,000",
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthChips() {
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul"];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: SizedBox(
          height: 30,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: months.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  // Log the index that was tapped
                  AppLogger.info(
                    'Tapped on month index: $index (${months[index]})',
                  );
                },
                child: _buildMonthChip(months[index], index == _selectedIndex),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMonthChip(String month, bool isSelected) {
    return Container(
      height: 35,
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryBlue : const Color(0xFFF5F1FF),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Text(
        month,
        style: GoogleFonts.nunitoSans(
          color: isSelected ? Colors.white : AppColors.primaryBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTdsList() {
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul"];
    final selectedMonth = months[_selectedIndex];
    final dataForSelectedMonth = monthData[selectedMonth] ?? [];

    return ListView.builder(
      itemCount: dataForSelectedMonth.length,
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final tdsData = dataForSelectedMonth[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, left: 15),
                      child: Text(
                        'Tds Payable',
                        style: FontStyles.bold700.copyWith(
                          fontSize: 18,
                          color: AppColors.primaryBlackFont,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryWhitebg,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '1',
                          style: FontStyles.bold700.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/pad-icon.svg',
                          height: 16,
                          width: 16,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primaryBlue,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            tdsData['tds'] ?? '0.00',
                            style: FontStyles.medium500.copyWith(
                              fontSize: 12,
                              color: AppColors.primaryLightGrayFont,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/calendar-right-svg.svg',
                          height: 16,
                          width: 16,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primaryBlue,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            tdsData['date'] ?? '00/00/0000',
                            style: FontStyles.medium500.copyWith(
                              fontSize: 12,
                              color: AppColors.primaryLightGrayFont,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
