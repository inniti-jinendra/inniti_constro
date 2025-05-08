class FetchAttendanceOnlyList {
  final String attendanceDate;
  final String inTime;
  final String outTime;
  final double presentHours;
  final String status;

  FetchAttendanceOnlyList({
    required this.attendanceDate,
    required this.inTime,
    required this.outTime,
    required this.presentHours,
    required this.status,
  });

  // From JSON (assuming you fetch data from an API)
  factory FetchAttendanceOnlyList.fromJson(Map<String, dynamic> json) {
    return FetchAttendanceOnlyList(
      attendanceDate: json['AttendanceDate'],
      inTime: json['InTime'],
      outTime: json['OutTime'],
      presentHours: json['PresentHours'],
      status: json['Status'],
    );
  }
}

class AttendanceItemList {
  final String? attendanceDate;
  final String? inTime;
  final String? outTime;
  final String? presentHours;
  final String? status;

  AttendanceItemList({
    this.attendanceDate,
    this.inTime,
    this.outTime,
    this.presentHours,
    this.status,
  });

  /// Converts a single `FetchAttendanceOnlyList` item to `AttendanceItemList`
  factory AttendanceItemList.fromFetchAttendanceOnlyList(FetchAttendanceOnlyList data) {
    return AttendanceItemList(
      attendanceDate: data.attendanceDate,
      inTime: data.inTime,
      outTime: data.outTime,
      presentHours: data.presentHours?.toString(), // Ensure it's a string
      status: data.status,
    );
  }

  /// Converts a list of `FetchAttendanceOnlyList` to a list of `AttendanceItemList`
  static List<AttendanceItemList> fromList(List<FetchAttendanceOnlyList> dataList) {
    return dataList
        .map((data) => AttendanceItemList.fromFetchAttendanceOnlyList(data))
        .toList();
  }

  @override
  String toString() {
    return 'AttendanceItemList(attendanceDate: $attendanceDate, inTime: $inTime, outTime: $outTime, presentHours: $presentHours, status: $status)';
  }
}







// class FetchAttendanceOnlyList {
//   int? statusCode;
//   String? message;
//   List<Data>? data;
//
//   FetchAttendanceOnlyList({this.statusCode, this.message, this.data});
//
//   FetchAttendanceOnlyList.fromJson(Map<String, dynamic> json) {
//     statusCode = json['StatusCode'];
//     message = json['Message'];
//     if (json['Data'] != null) {
//       data = <Data>[];
//       json['Data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['StatusCode'] = this.statusCode;
//     data['Message'] = this.message;
//     if (this.data != null) {
//       data['Data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class Data {
  String? attendanceDate;
  String? inTime;
  String? outTime;
  int? presentHours;
  String? status;

  Data(
      {this.attendanceDate,
        this.inTime,
        this.outTime,
        this.presentHours,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    attendanceDate = json['AttendanceDate'];
    inTime = json['InTime'];
    outTime = json['OutTime'];
    presentHours = json['PresentHours'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AttendanceDate'] = this.attendanceDate;
    data['InTime'] = this.inTime;
    data['OutTime'] = this.outTime;
    data['PresentHours'] = this.presentHours;
    data['Status'] = this.status;
    return data;
  }
}
