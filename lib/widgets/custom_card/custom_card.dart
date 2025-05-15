// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// // labor card
//
// class CustomCard extends StatelessWidget {
//   final String title;
//   final String? subtitle;
//   final String? badgeText;
//   final String? iconPath;
//   final bool showToggle;
//   final bool initialToggleValue;
//   final ValueChanged<bool>? onToggle;
//   final VoidCallback? onTap;
//
//   const CustomCard({
//     super.key,
//     required this.title,
//     this.subtitle,
//     this.badgeText,
//     this.iconPath,
//     this.showToggle = false,
//     this.initialToggleValue = false,
//     this.onToggle,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // ✅ Title (Main Label)
//                   Expanded(
//                     child: Text(
//                       title,
//                       style: GoogleFonts.nunitoSans(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//
//                   // ✅ Badge (Optional)
//                   if (badgeText != null)
//                     Container(
//                       height: 32,
//                       width: 32,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade100,
//                         borderRadius: const BorderRadius.only(
//                           topRight: Radius.circular(12),
//                           bottomLeft: Radius.circular(12),
//                         ),
//                       ),
//                       child: Text(
//                         badgeText!,
//                         style: GoogleFonts.nunitoSans(
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue.shade900,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//
//               // ✅ Subtitle Row (Icon + Text)
//               if (subtitle != null || iconPath != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 6),
//                   child: Row(
//                     children: [
//                       if (iconPath != null) ...[
//                         SvgPicture.asset(
//                           iconPath!,
//                           height: 16,
//                           width: 16,
//                           colorFilter: const ColorFilter.mode(
//                             Colors.grey,
//                             BlendMode.srcIn,
//                           ),
//                         ),
//                         const SizedBox(width: 6),
//                       ],
//                       if (subtitle != null)
//                         Text(
//                           subtitle!,
//                           style: GoogleFonts.nunitoSans(
//                             fontSize: 14,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//
//               // ✅ Toggle Switch (Optional)
//               if (showToggle)
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: Transform.scale(
//                     scale: 0.7,
//                     child: Switch(
//                       value: initialToggleValue,
//                       onChanged: onToggle,
//                       activeColor: Colors.green,
//                       inactiveThumbColor: Colors.red,
//                       activeTrackColor: Colors.green[200],
//                       inactiveTrackColor: Colors.red[200],
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// labor list active or not card

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/font_styles.dart';

class LabourCard extends StatefulWidget {
  final String id;
  final String name;
  final String company;
  final bool status;
  final ValueChanged<bool> onToggle;

  const LabourCard({
    super.key,
    required this.id,
    required this.name,
    required this.company,
    required this.status,
    required this.onToggle,
  });

  @override
  State<LabourCard> createState() => _LabourCardState();
}

class _LabourCardState extends State<LabourCard> {
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _isActive = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: const EdgeInsets.symmetric(vertical: 8),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0x405B21B1), // 40 is hex for 25% opacity
            offset: Offset(0, 0),     // Matches 0px 0px
            blurRadius: 14,
            spreadRadius: -6,         // Negative spread like CSS
          ),
        ],
      ),

      child: Container(
        height: 85,
        decoration: BoxDecoration(
          color: _isActive ? AppColors.white: Color(0x99f8f9fa),
          //color: _isActive ? AppColors.white: AppColors.whitewithOps,
          borderRadius: BorderRadius.circular(12),
        ),
        //padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // ✅ Better spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Labour Name (with proper padding & alignment)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ), // ✅ Optimized padding
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Container(
                        child: Text(
                          widget.name,
                          style: FontStyles.bold700.copyWith(
                            height: 1.0, // Equivalent to 100% line-height
                            letterSpacing: 0.0,
                            fontSize: 18,
                            color: _isActive ? AppColors.primaryBlackFont : AppColors.primaryBlackFontWithOpps60,
                          ),
                          overflow:
                          TextOverflow.ellipsis, // ✅ Prevents text overflow
                        ),
                      ),
                    ),
                  ),
                ),

                // 🔴 Custom ID Badge (Aligned to top-right)
                Container(
                  // height: 38,
                  // // ✅ Slightly smaller for better proportion
                  // width: 38,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryWhitebg,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 8
                    ),
                    child: Text(
                      widget.id,
                     // "1",
                      style: FontStyles.bold700.copyWith(
                       // fontSize: 10,
                        fontSize: 15, // ✅ Adjusted for readability
                      //  color: AppColors.primaryBlueFont,
                         color: _isActive ? AppColors.primaryBlue : AppColors.primaryBlueWithOps60,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ✅ Company Name Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (widget.company.isNotEmpty) ...[
                        // 📌 SVG Icon (Left Side)
                        SvgPicture.asset(
                          'assets/icons/home-iocn/pin-icon.svg',
                          height: 16, // ✅ Adjust size as needed
                          width: 16,
                         color: _isActive ? AppColors.primaryBlue : AppColors.primaryBlueWithOps60,
                          // colorFilter: const ColorFilter.mode(
                          //   Colors.grey,
                          //   BlendMode.srcIn,
                          // ), // ✅ Set color
                        ),

                        const SizedBox(width: 3), // ✅ Space between icon & text
                        // 📌 Company Name Text
                        Text(
                          widget.company.length > 25
                              ? widget.company.substring(0, 20) + '...'
                              : widget.company,
                          style: FontStyles.medium500.copyWith(
                            fontSize: 11,
                            color:  _isActive ? AppColors.primaryLightGrayFont : AppColors.primaryLightGrayFontWithOps60,
                          ),
                        ),
                      ] else
                        // 📌 Black Container (Shown when company name is empty)
                        SizedBox(height: 20, width: 50),
                    ],
                  ),

                  // ✅ Toggle Switch (Aligned Right & Smaller)
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: Transform.scale(
                  //     scale: 0.5, // ✅ Adjusted to a reasonable small size
                  //     child: Switch(
                  //       value: _isActive,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           _isActive = value;
                  //           widget.onToggle(value);
                  //         });
                  //       },
                  //       activeColor: Colors.green,
                  //       inactiveThumbColor: Colors.red,
                  //       activeTrackColor: Colors.green[200],
                  //       inactiveTrackColor: Colors.red[200],
                  //     ),
                  //   ),
                  // ),

      Container(
        width: 38,
        height: 23,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isActive = !_isActive;
              widget.onToggle(_isActive);
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 250),
            padding: EdgeInsets.symmetric(horizontal: 4), // reduce padding to let color fill more
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              //color: Colors.red.shade300, // slightly darker for better fill effect
              color: _isActive ? Color(0xff96e9b7) : Color(0xffdb8484), // slightly darker for better fill effect
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
              alignment: _isActive ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isActive ? Color(0xff2DD36F) : Color(0xffB70909),
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
                  _isActive ? 'A' : 'D',
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


      ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
