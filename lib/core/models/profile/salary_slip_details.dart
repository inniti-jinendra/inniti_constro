class SalarySlipDetails {
  int userId;
  String employeeName;
  String fromDate;
  String toDate;
  String month;
  String year;
  String employeeSalaryDetailsID;

  SalarySlipDetails(
      {required this.userId,
      required this.employeeName,
      required this.fromDate,
      required this.toDate,
      required this.month,
      required this.year,
      required this.employeeSalaryDetailsID});

  factory SalarySlipDetails.fromJson(Map<String, dynamic> json) {
    return SalarySlipDetails(
      userId: json["UserID"],
      employeeSalaryDetailsID: json["EmployeeSalaryDetailsID"],
      employeeName: json["EmployeeName"],
      fromDate: json["FromDate"],
      toDate: json["ToDate"],
      month: json["Month"],
      year: json["Year"],
    );
  }
}
