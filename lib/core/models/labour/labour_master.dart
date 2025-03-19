class Labour {
  int labourID;
  int? supplierId;
  String labourSex;
  String labourFirstName;
  String? labourMiddleName;
  String? labourLastName;
  int? labourAge;
  String? labourContactNo;
  String? labourAadharNo;
  String? labourProfilePic; // File path or base64 string
  int labourWorkingHrs;
  double totalWages;
  double? otRate;
  String? labourCategory;
  String? companyCode;
  int? createdBy;
  int? lastUpdatedBy;

  Labour(
      {required this.labourID,
      required this.supplierId,
      required this.labourSex,
      required this.labourFirstName,
      this.labourMiddleName,
      this.labourLastName,
      this.labourAge,
      this.labourContactNo,
      this.labourAadharNo,
      this.labourProfilePic,
      required this.labourWorkingHrs,
      required this.totalWages,
      this.otRate,
      this.labourCategory,
      this.companyCode,
      this.createdBy,
      this.lastUpdatedBy});

  Map<String, dynamic> toJson() {
    return {
      "LABOUR_ID": labourID,
      "SUPPLIER_ID": supplierId,
      "LABOUR_SEX": labourSex,
      "LABOUR_FIRSTNAME": labourFirstName,
      "LABOUR_MIDDLENAME": labourMiddleName,
      "LABOUR_LASTNAME": labourLastName,
      "LABOUR_AGE": labourAge,
      "LABOUR_CONTACTNO": labourContactNo,
      "LABOUR_AADHARNO": labourAadharNo,
      "LABOUR_PROFILEPIC": labourProfilePic,
      "LABOUR_WORKINGHRS": labourWorkingHrs,
      "TOTALWAGES": totalWages,
      "OTRATE": otRate,
      "LABOUR_CATEGORY": labourCategory,
      "companyCode": companyCode,
      "CREATED_BY": createdBy,
      "LAST_UPDATED_BY": lastUpdatedBy,
    };
  }

  factory Labour.fromJson(Map<String, dynamic> json) {
    return Labour(
        labourID: json['LABOUR_ID'],
        supplierId: json['SUPPLIER_ID'],
        labourSex: json['LABOUR_SEX'] ?? '',
        labourFirstName: json['LABOUR_FIRSTNAME'] ?? '',
        labourMiddleName: json['LABOUR_MIDDLENAME'] ?? '',
        labourLastName: json['LABOUR_LASTNAME'] ?? '',
        labourAge: json['LABOUR_AGE'] ?? '0',
        labourContactNo: json['LABOUR_CONTACTNO'] ?? '',
        labourProfilePic: json['LABOUR_PROFILEPIC'] ?? '',
        labourAadharNo: json['LABOUR_AADHARNO'] ?? '',
        labourWorkingHrs: json['LABOUR_WORKINGHRS'] ?? "0",
        totalWages: json['TOTALWAGES'] ?? "0",
        otRate: json['OTRATE'] ?? "0",
        labourCategory: json['LABOUR_CATEGORY'] ?? "");
  }
}
