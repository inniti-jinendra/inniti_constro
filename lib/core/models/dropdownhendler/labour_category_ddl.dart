class LabourCategoryItem {
  final String labourCategoryValue;
  final String labourCategoryText;

  LabourCategoryItem({
    required this.labourCategoryValue,
    required this.labourCategoryText,
  });

  factory LabourCategoryItem.fromJson(Map<String, dynamic> json) {
    return LabourCategoryItem(
      labourCategoryValue: json['LabourCategoryValue'],
      labourCategoryText: json['LabourCategoryText'],
    );
  }
}
