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

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';

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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: _isActive ? Colors.white : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        //padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // ✅ Better spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ✅ Labour Name (with proper padding & alignment)
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
                          style: GoogleFonts.nunitoSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _isActive ? Colors.black87 : Colors.grey,
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
                  height: 38,
                  // ✅ Slightly smaller for better proportion
                  width: 38,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryWhitebg,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.id,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 10,
                      //fontSize: 16, // ✅ Adjusted for readability
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlueFont,
                    ),
                  ),
                ),
              ],
            ),

            // ✅ Company Name Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
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
                          colorFilter: const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.srcIn,
                          ), // ✅ Set color
                        ),

                        const SizedBox(width: 6), // ✅ Space between icon & text
                        // 📌 Company Name Text
                        Text(
                          widget.company.length > 25 ? widget.company.substring(0, 20) + '...' : widget.company,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),

                      ] else
                      // 📌 Black Container (Shown when company name is empty)
                        SizedBox(height: 20, width: 50),
                    ],
                  ),

                  // ✅ Toggle Switch (Aligned Right & Smaller)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Transform.scale(
                      scale: 0.5, // ✅ Adjusted to a reasonable small size
                      child: Switch(
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                            widget.onToggle(value);
                          });
                        },
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.red,
                        activeTrackColor: Colors.green[200],
                        inactiveTrackColor: Colors.red[200],
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