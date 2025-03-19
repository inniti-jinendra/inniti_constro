class EmpAttendance {
  String? empAttendanceID;
  int userID;
  String? inOutTime_Latitude;
  String? inOutTime_Longitude;
  String? inOutTime_GeoAddress;
  int? projectID;
  String? inOutTime_Base64Image;
  String? selfAttendanceType;
  String? companyCode;

  EmpAttendance({
    this.empAttendanceID,
    required this.userID,
    this.inOutTime_Latitude,
    this.inOutTime_Longitude,
    this.inOutTime_GeoAddress,
    this.projectID,
    this.inOutTime_Base64Image,
    this.selfAttendanceType,
    this.companyCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "EmpAttendanceID": empAttendanceID,
      "UserID": userID,
      "InOutTime_Latitude": inOutTime_Latitude,
      "InOutTime_Longitude": inOutTime_Longitude,
      "InOutTime_GeoAddress": inOutTime_GeoAddress,
      "ProjectID": projectID,
      "InOutTime_Base64Image": inOutTime_Base64Image,
      "SelfAttendanceType": selfAttendanceType,
      "companyCode": companyCode,
    };
  }
}
