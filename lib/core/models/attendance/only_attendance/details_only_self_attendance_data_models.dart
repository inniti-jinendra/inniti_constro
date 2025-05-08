class FetchAttendanceOnlyDetails {
  final String userName;
  final String profilePhotoUrl;
  final String address;
  final int presentCount;
  final int leaveCount;
  final int absentCount;
  final int employeeId;

  FetchAttendanceOnlyDetails({
    required this.userName,
    required this.profilePhotoUrl,
    required this.address,
    required this.presentCount,
    required this.leaveCount,
    required this.absentCount,
    required this.employeeId,
  });

  factory FetchAttendanceOnlyDetails.fromJson(Map<String, dynamic> json) {
    return FetchAttendanceOnlyDetails(
      userName: json['UserName'] ?? '',
      profilePhotoUrl: json['ProfilePhotoUrl'] ?? '',
      address: json['Address'] ?? '',
      presentCount: json['PresentCount'] ?? 0,
      leaveCount: json['LeaveCount'] ?? 0,
      absentCount: json['AbsentCount'] ?? 0,
      employeeId: json['EmployeeID'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'UserName: $userName, Present: $presentCount, Leave: $leaveCount, Absent: $absentCount, EmployeeID: $employeeId';
  }
}
