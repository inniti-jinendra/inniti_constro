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
  final int empAttendanceId;
  final int employeeCode;
  final String employeeName;
  final String designationName;
  final String? inTime;
  final String? outTime;
  final int presentHours;
  final String? inDocumentPath;
  final String? outDocumentPath;

  SelfAttendanceData({
    required this.empAttendanceId,
    required this.employeeCode,
    required this.employeeName,
    required this.designationName,
    this.inTime,
    this.outTime,
    required this.presentHours,
    this.inDocumentPath,
    this.outDocumentPath,
  });

  factory SelfAttendanceData.fromJson(Map<String, dynamic> json) {
    return SelfAttendanceData(
      empAttendanceId: json['EmpAttendanceId'] ?? 0,
      employeeCode: json['EmployeeCode'] ?? 0,
      employeeName: json['EmployeeName'] ?? '',
      designationName: json['DesignationName'] ?? '',
      inTime: json['InTime'],
      outTime: json['OutTime'],
      presentHours: json['PresentHours'] ?? 0,
      inDocumentPath: json['inDocumentPath'],
      outDocumentPath: json['OutDocumentPath'],
    );
  }
}



