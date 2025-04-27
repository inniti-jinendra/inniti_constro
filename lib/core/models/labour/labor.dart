// ✅ API Model
class Labour {
  final int labourID;
  final String labourCode;
  final String labourProfilePic;
  final String labourName;
  final String labourCategory;
  final String contractorName;
  final String isActive;
  final int totalCount;

  Labour({
    required this.labourID,
    required this.labourCode,
    required this.labourProfilePic,
    required this.labourName,
    required this.labourCategory,
    required this.contractorName,
    required this.isActive,
    required this.totalCount,
  });

  factory Labour.fromJson(Map<String, dynamic> json) {
    return Labour(
      labourID: json['LabourID'] ?? 0,
      labourCode: json['LabourCode'] ?? '',
      labourProfilePic:
      json['LabourProfilePic'] ??
          'http://192.168.1.17:1011/Files/ProfilePic/nopic.png',
      labourName: json['LabourName'] ?? '',
      labourCategory: json['LabourCategory'] ?? 'Unknown',
      contractorName: json['ContractorName'] ?? '',
      isActive: json['IsActive'] ?? 'Inactive',
      totalCount: json['TotalCount'] ?? 0,
    );
  }
}

class LabourModel {
  final int? labourID;
  final String? labourCode;
  final String? labourFirstName;
  final String? labourMiddleName;
  final String? labourLastName;
  final int? labourAge;
  final String? labourSex;
  final String? labourContactNo;
  final String? labourAadharNo;
  final int? labourWorkingHrs;
  final double? otRate;
  final double? totalWages;
  final double? commissionPerLabour;
  final String? contractorName;
  final String? labourCategory;
  final int? contractorID;

  LabourModel({
    this.labourID,
    this.labourCode,
    this.labourFirstName,
    this.labourMiddleName,
    this.labourLastName,
    this.labourAge,
    this.labourSex,
    this.labourContactNo,
    this.labourAadharNo,
    this.labourWorkingHrs,
    this.otRate,
    this.totalWages,
    this.commissionPerLabour,
    this.contractorName,
    this.labourCategory,
    this.contractorID,
  });

  factory LabourModel.fromJson(Map<String, dynamic> json) {
    return LabourModel(
      labourID: json['LABOUR_ID'],
      labourCode: json['LabourCode'],
      labourFirstName: json['LABOUR_FIRSTNAME'],
      labourMiddleName: json['LABOUR_MIDDLENAME'],
      labourLastName: json['LABOUR_LASTNAME'],
      labourAge: json['LABOUR_AGE'],
      labourSex: json['LABOUR_SEX'],
      labourContactNo: json['LABOUR_CONTACTNO'],
      labourAadharNo: json['LABOUR_AADHARNO'],
      labourWorkingHrs: json['LABOUR_WORKINGHRS'],
      otRate: (json['OTRATE'] as num?)?.toDouble(),
      totalWages: (json['TOTALWAGES'] as num?)?.toDouble(),
      commissionPerLabour: (json['COMMISSION_PER_LABOUR'] as num?)?.toDouble(),
      contractorName: json['CONTRACTOR_NAME'] ?? json['SUPPLIER_NAME'], // Optional - not in this response but safe to include
      labourCategory: json['LABOUR_CATEGORY'],
      contractorID: json['SUPPLIER_ID'],
    );
  }

  Map<String, dynamic> toJson() => {
    "LABOUR_ID": labourID,
    "LABOUR_FIRSTNAME": labourFirstName,
    "LABOUR_MIDDLENAME": labourMiddleName,
    "LABOUR_LASTNAME": labourLastName,
    "LABOUR_AGE": labourAge,
    "LABOUR_SEX": labourSex,
    "LABOUR_CONTACTNO": labourContactNo,
    "LABOUR_AADHARNO": labourAadharNo,
    "LABOUR_WORKINGHRS": labourWorkingHrs,
    "OTRATE": otRate,
    "TOTALWAGES": totalWages,
    "COMMISSION_PER_LABOUR": commissionPerLabour,
    "CONTRACTOR_NAME": contractorName,
    "LABOUR_CATEGORY": labourCategory,
    "SUPPLIER_ID": contractorID,
  };
}



