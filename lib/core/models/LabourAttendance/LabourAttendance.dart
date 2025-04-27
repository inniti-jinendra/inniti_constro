class LabourAttendance {
  final int labourID;
  final int LabourAttendanceID;
  final String labourCode;
  final String labourName;
  final String contractorName;
  final int plantID;
  final String attendance;
  final int totalPresent;
  final String labourCategory;
  final int totalCount;

  LabourAttendance({
    required this.labourID,
    required this.LabourAttendanceID,
    required this.labourCode,
    required this.labourName,
    required this.contractorName,
    required this.plantID,
    required this.attendance,
    required this.totalPresent,
    required this.labourCategory,
    required this.totalCount,
  });

  factory LabourAttendance.fromJson(Map<String, dynamic> json) {
    return LabourAttendance(
      labourID: json['LabourID'] ?? 0,  // Default to 0 if null
      LabourAttendanceID: json['LabourAttendanceID'] ?? 0,  // Default to 0 if null
      labourCode: json['LabourCode'].toString(),  // Convert to string
      labourName: json['LabourName'] ?? 'Unknown',  // Default value if null
      contractorName: json['ContractorName'] ?? '',
      plantID: json['PlantID'] ?? 0,
      attendance: json['Attendance'] ?? 'N/A',  // Default if null
      totalPresent: json['TotalPresent'] ?? 0,
      labourCategory: json['LabourCategory'] ?? 'Unknown',
      totalCount: json['TotalCount'] ?? 0,
    );
  }
}

class LabourAttendanceedit {
  final int labourID;
  final int LabourAttendanceID;
  final String labourCode;
  final String labourName;
  final String contractorName;
  final int plantID;
  final String attendance;
  final int totalPresent;
  final String labourCategory;
  final int totalCount;

  final DateTime? inTime;
  final DateTime? outTime;
  final double totalHrs;
  final String? inDocumentPath;
  final String? outDocumentPath;
  final String? remark;

  LabourAttendanceedit({
    required this.labourID,
    required this.LabourAttendanceID,
    required this.labourCode,
    required this.labourName,
    required this.contractorName,
    required this.plantID,
    required this.attendance,
    required this.totalPresent,
    required this.labourCategory,
    required this.totalCount,
    this.inTime,
    this.outTime,
    required this.totalHrs,
    this.inDocumentPath,
    this.outDocumentPath,
    this.remark,
  });

  factory LabourAttendanceedit.fromJson(Map<String, dynamic> json) {
    return LabourAttendanceedit(
      labourID: json['LABOUR_ID'] ?? 0,
      LabourAttendanceID: json['LABOUR_ATTENDANCEID'] ?? 0,
      labourCode: json['LabourCode']?.toString() ?? '',
      labourName: json['LabourName'] ?? 'Unknown',
      contractorName: json['ContractorName'] ?? '',
      plantID: json['PLANT_ID'] ?? 0,
      attendance: json['IS_PRESENT'] ?? 'N/A',
      totalPresent: json['TotalPresent'] ?? 0,
      labourCategory: json['LabourCategory'] ?? 'Unknown',
      totalCount: json['TotalCount'] ?? 0,
      inTime: json['IN_TIME'] != null ? DateTime.tryParse(json['IN_TIME']) : null,
      outTime: json['OUT_TIME'] != null ? DateTime.tryParse(json['OUT_TIME']) : null,
      totalHrs: (json['TOTAL_HRS'] ?? 0).toDouble(),
      inDocumentPath: json['IN_PICTURE'],
      outDocumentPath: json['OUT_PICTURE'],
      remark: json['REMARK'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LABOUR_ID': labourID,
      'LABOUR_ATTENDANCEID': LabourAttendanceID,
      'LabourCode': labourCode,
      'LabourName': labourName,
      'ContractorName': contractorName,
      'PLANT_ID': plantID,
      'IS_PRESENT': attendance,
      'TotalPresent': totalPresent,
      'LabourCategory': labourCategory,
      'TotalCount': totalCount,
      'IN_TIME': inTime?.toIso8601String(),
      'OUT_TIME': outTime?.toIso8601String(),
      'TOTAL_HRS': totalHrs,
      'IN_PICTURE': inDocumentPath,
      'OUT_PICTURE': outDocumentPath,
      'REMARK': remark,
    };
  }
}


class LabourAttendanceModel {
  final String? inTime;
  final String? outTime;
  final String? remarks;
  final String? projectType;

  LabourAttendanceModel({
    this.inTime,
    this.outTime,
    this.remarks,
    this.projectType,
  });

  factory LabourAttendanceModel.fromJson(Map<String, dynamic> json) {
    return LabourAttendanceModel(
      inTime: json['inTime'],
      outTime: json['outTime'],
      remarks: json['remarks'],
      projectType: json['projectType'],
    );
  }
}

