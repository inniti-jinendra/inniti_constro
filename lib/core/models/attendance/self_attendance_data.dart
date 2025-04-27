// class SelfAttendanceData {
//   String employeeCode;
//   String employeeName;
//   String designationName;
//   String inTime;
//   String outTime;
//   String empAttendanceId;
//   String inDocumentPath;
//   String outDocumentPath;
//
//   SelfAttendanceData(
//       {required this.employeeCode,
//       required this.employeeName,
//       required this.designationName,
//       required this.inTime,
//       required this.outTime,
//       required this.empAttendanceId,
//       required this.inDocumentPath,
//       required this.outDocumentPath});
//
//   factory SelfAttendanceData.fromJson(Map<String, dynamic> json) =>
//       SelfAttendanceData(
//         employeeCode: json["EmployeeCode"],
//         employeeName: json["EmployeeName"],
//         designationName: json["DesignationName"],
//         inTime: json["InTime"],
//         outTime: json["OutTime"],
//         empAttendanceId: json["EmpAttendanceId"],
//         inDocumentPath: json["inDocumentPath"],
//         outDocumentPath: json["OutDocumentPath"],
//       );
// }



class SelfAttendanceData {
  final DateTime? inTime;
  final DateTime? outTime;
  final bool? isLeave;
  final String empAttendanceId;
  final String employeeCode;
  final String employeeName;
  final String designationName;
  final Duration presentHours;
  final String? inDocumentPath;
  final String? outDocumentPath;

  SelfAttendanceData({
    this.inTime,
    this.outTime,
    this.isLeave,
    required this.empAttendanceId,
    required this.employeeCode,
    required this.employeeName,
    required this.designationName,
    required this.presentHours,
    this.inDocumentPath,
    this.outDocumentPath,
  });

  factory SelfAttendanceData.fromJson(Map<String, dynamic> json) {
    return SelfAttendanceData(
      inTime: json['InTime'] != null ? DateTime.parse(json['InTime']) : null,
      outTime: json['OutTime'] != null ? DateTime.parse(json['OutTime']) : null,
      isLeave: json['IsLeave'] ?? false,
      empAttendanceId: json['EmpAttendanceId']?.toString() ?? '',
      employeeCode: json['EmployeeCode']?.toString() ?? '',
      employeeName: json['EmployeeName'] ?? '',
      designationName: json['DesignationName'] ?? '',
      presentHours: Duration(seconds: json['PresentHours'] ?? 0),
      inDocumentPath: json['inDocumentPath'],
      outDocumentPath: json['OutDocumentPath'],
    );
  }

  @override
  String toString() {
    return 'SelfAttendanceData(inTime: $inTime, outTime: $outTime, isLeave: $isLeave, empAttendanceId: $empAttendanceId, employeeCode: $employeeCode, employeeName: $employeeName, designationName: $designationName, presentHours: ${presentHours.inHours} hours ${presentHours.inMinutes % 60} minutes, inDocumentPath: $inDocumentPath, outDocumentPath: $outDocumentPath)';
  }
}


