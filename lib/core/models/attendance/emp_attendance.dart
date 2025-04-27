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


class Attendance {
  String companyCode;
  int empAttendanceID;
  DateTime date;
  int userID;
  DateTime createdUpdateDate;
  DateTime inOutTime;
  String inOutTimeBase64Image;
  double inOutTimeLatitude;
  double inOutTimeLongitude;
  String inOutTimeGeoAddress;
  int projectID;
  String fileName;
  String selfAttendanceType;

  Attendance({
    required this.companyCode,
    required this.empAttendanceID,
    required this.date,
    required this.userID,
    required this.createdUpdateDate,
    required this.inOutTime,
    required this.inOutTimeBase64Image,
    required this.inOutTimeLatitude,
    required this.inOutTimeLongitude,
    required this.inOutTimeGeoAddress,
    required this.projectID,
    required this.fileName,
    required this.selfAttendanceType,
  });

  Map<String, dynamic> toJson() {
    return {
      'CompanyCode': companyCode,
      'EmpAttendanceID': empAttendanceID,
      'Date': date.toIso8601String(),
      'UserID': userID,
      'CreatedUpdateDate': createdUpdateDate.toIso8601String(),
      'InOutTime': inOutTime.toIso8601String(),
      'InOutTime_Base64Image': inOutTimeBase64Image,
      'InOutTime_Latitude': inOutTimeLatitude.toString(),
      'InOutTime_Longitude': inOutTimeLongitude.toString(),
      'InOutTime_GeoAddress': inOutTimeGeoAddress,
      'ProjectID': projectID,
      'FileName': fileName,
      'SelfAttendanceType': selfAttendanceType,
    };
  }
}

// // Example of creating the Attendance object
// Attendance empAttendance = Attendance(
//   companyCode: 'CONSTRO',
//   empAttendanceID: 0,
//   date: DateTime.parse('2025-04-09T10:33:00'),
//   userID: 13125,
//   createdUpdateDate: DateTime.parse('2025-04-09T10:33:00'),
//   inOutTime: DateTime.parse('2025-04-09T10:33:00'),
//   inOutTimeBase64Image: "iVBORw0KGgoAAAANSUhEUgAAAfQAAAH0CAYAAADL1t wMQTcaCXqP5oQAAAABJRU5ErkJggg==",
//   inOutTimeLatitude: 0.00,
//   inOutTimeLongitude: 0.00,
//   inOutTimeGeoAddress: 'Gota',
//   projectID: 1000,
//   fileName: 'demo.png',
//   selfAttendanceType: 'IN',
// );

// // Convert to JSON
// String requestBody = jsonEncode(empAttendance.toJson());
//
// // Print the request body
// print(requestBody);

