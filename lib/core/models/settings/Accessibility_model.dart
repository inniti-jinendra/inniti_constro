// class AccessibilityItem {
//   final int appMenuID;
//   final String menuName;
//   final bool isAccessible;
//
//   AccessibilityItem({
//     required this.appMenuID,
//     required this.menuName,
//     required this.isAccessible,
//   });
//
//   factory AccessibilityItem.fromJson(Map<String, dynamic> json) {
//     return AccessibilityItem(
//       appMenuID: json['AppMenuID'],
//       menuName: json['MenuName'],
//       isAccessible: json['Is_Accessible'],
//     );
//   }
// }

class AccessibilityItem {
  final int appMenuID;
  final String menuName;
  final bool isAccessible;

  AccessibilityItem({
    required this.appMenuID,
    required this.menuName,
    required this.isAccessible,
  });

  factory AccessibilityItem.fromJson(Map<String, dynamic> json) {
    return AccessibilityItem(
      appMenuID: json['AppMenuID'],
      menuName: json['MenuName'],
      isAccessible: json['Is_Accessible'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AppMenuID': appMenuID,
      'MenuName': menuName,
      'Is_Accessible': isAccessible,
    };
  }

  AccessibilityItem copyWith({
    int? appMenuID,
    String? menuName,
    bool? isAccessible,
  }) {
    return AccessibilityItem(
      appMenuID: appMenuID ?? this.appMenuID,
      menuName: menuName ?? this.menuName,
      isAccessible: isAccessible ?? this.isAccessible,
    );
  }
}
