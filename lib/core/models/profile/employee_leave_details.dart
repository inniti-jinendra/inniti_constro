class EmployeeLeaveDetails {
  int userId;
  String leaveBalance;
  String totalLeave;

  EmployeeLeaveDetails({
    required this.userId,
    required this.leaveBalance,
    required this.totalLeave,
  });

  factory EmployeeLeaveDetails.fromJson(Map<String, dynamic> json) =>
      EmployeeLeaveDetails(
        userId: json["UserID"],
        leaveBalance: json["LeaveBalance"],
        totalLeave: json["TotalLeave"],
      );
}
