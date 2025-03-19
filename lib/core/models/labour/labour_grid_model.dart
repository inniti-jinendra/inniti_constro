class LabourGrid {
  final int labourId;
  final String labourCode;
  final String firstName;
  final String lastName;
  final String category;
  final String contactNo;
  final String profilePic;
  final String contractorName;
  final String totalWages;
  final String age;
  final String isActive;

  LabourGrid({
    required this.labourId,
    required this.labourCode,
    required this.firstName,
    required this.lastName,
    required this.category,
    required this.contactNo,
    required this.profilePic,
    required this.contractorName,
    required this.totalWages,
    required this.age,
    required this.isActive,
  });

  // Factory method to parse JSON into a Labour object
  factory LabourGrid.fromJson(Map<String, dynamic> json) {
    return LabourGrid(
      labourId: json['LABOUR_ID'],
      labourCode: json['LABOUR_CODE'] ?? '',
      firstName: json['LABOUR_FIRSTNAME'] ?? '',
      lastName: json['LABOUR_LASTNAME'] ?? '',
      category: json['LABOUR_CATEGORY'] ?? '',
      contactNo: json['LABOUR_CONTACTNO'] ?? '',
      profilePic: json['LABOUR_PROFILEPIC'] ?? '',
      contractorName: json['CONTRACTOR_NAME'] ?? '',
      totalWages: json['TOTALWAGES'] ?? '',
      age: json['LABOUR_AGE'] ?? "0",
      isActive: json['IS_ACTIVE'] ?? "",
    );
  }
}
