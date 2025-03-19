class SelfAttendanceData {
  String employeeCode;
  String employeeName;
  String designationName;
  String inTime;
  String outTime;
  String empAttendanceId;
  String inDocumentPath;
  String outDocumentPath;

  SelfAttendanceData(
      {required this.employeeCode,
      required this.employeeName,
      required this.designationName,
      required this.inTime,
      required this.outTime,
      required this.empAttendanceId,
      required this.inDocumentPath,
      required this.outDocumentPath});

  factory SelfAttendanceData.fromJson(Map<String, dynamic> json) =>
      SelfAttendanceData(
        employeeCode: json["EmployeeCode"],
        employeeName: json["EmployeeName"],
        designationName: json["DesignationName"],
        inTime: json["InTime"],
        outTime: json["OutTime"],
        empAttendanceId: json["EmpAttendanceId"],
        inDocumentPath: json["inDocumentPath"],
        outDocumentPath: json["OutDocumentPath"],
      );
}
