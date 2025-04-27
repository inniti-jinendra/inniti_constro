

import 'package:flutter/material.dart';

class LabourAttendance {
  final int labourId;
  final int labourAttendanceId;
  final String labourName;
  final String contractorName;
  final String? labourCode;
  final int plantId;
  final String isPresent;
  final int totalPresent;
  final String labourCategory;
  final int totalCount;
  final DateTime? inTime;
  final DateTime? outTime;
  final double totalHrs;
  final String? inPicture;
  final String? outPicture;
  final String? remark;
  final double? overTime;
  final double? overtimeRate;
  final double? inLatitude;
  final double? inLongitude;
  final double? outLatitude;
  final double? outLongitude;
  final String? inGeoAddress;
  final String? outGeoAddress;
  final String? activityName;
  final int? projectItemTypeId;
  final bool? isApproved;
  final bool? isPaid;

  final DateTime? date;
  final String? inDocumentPath;
  final String? outDocumentPath;
  final int? createdBy;
  final DateTime? createdDate;
  final int? lastUpdatedBy;
  final DateTime? lastUpdatedDate;
  final bool? isDeleted;
  final int? approvedBy;
  final DateTime? approvedDate;
  final String? status;
  final int? contractorId;
  final String? base64Image;
  final String? fileName;

  LabourAttendance({
    required this.labourId,
    required this.labourAttendanceId,
    required this.labourName,
    required this.contractorName,
    required this.labourCode,
    required this.plantId,
    required this.isPresent,
    required this.totalPresent,
    required this.labourCategory,
    required this.totalCount,
    this.inTime,
    this.outTime,
    required this.totalHrs,
    this.inPicture,
    this.outPicture,
    this.remark,
    this.overTime,
    this.overtimeRate,
    this.inLatitude,
    this.inLongitude,
    this.outLatitude,
    this.outLongitude,
    this.inGeoAddress,
    this.outGeoAddress,
    this.activityName,
    this.projectItemTypeId,
    this.isApproved,
    this.isPaid,
    this.date,
    this.inDocumentPath,
    this.outDocumentPath,
    this.createdBy,
    this.createdDate,
    this.lastUpdatedBy,
    this.lastUpdatedDate,
    this.isDeleted,
    this.approvedBy,
    this.approvedDate,
    this.status,
    this.contractorId,
    this.base64Image,
    this.fileName,
  });

  factory LabourAttendance.fromJson(Map<String, dynamic> json) {
    double? parseToDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    DateTime? parseTimeToDateTime(String? timeStr) {
      if (timeStr == null || timeStr.isEmpty) return null;
      if (timeStr.contains('T')) {
        return DateTime.tryParse(timeStr);
      } else {
        final now = DateTime.now();
        final parts = timeStr.split(':');
        if (parts.length < 2) return null;
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;
        return DateTime(now.year, now.month, now.day, hour, minute);
      }
    }

    final parsedInTime = parseTimeToDateTime(json["IN_TIME"]);
    final parsedOutTime = parseTimeToDateTime(json["OUT_TIME"]);

    print("🕒 Parsed InTime: ${json["IN_TIME"]} => $parsedInTime");
    print("🕒 Parsed OutTime: ${json["OUT_TIME"]} => $parsedOutTime");

    return LabourAttendance(
      labourId: json["LABOUR_ID"] ?? 0,
      labourAttendanceId: json["LABOUR_ATTENDANCEID"] ?? 0,
      labourName: json["LabourName"] ?? '',
      contractorName: json["ContractorName"] ?? '',
      labourCode: json["LabourCode"],
      plantId: json["PLANT_ID"] ?? 0,
      isPresent: json["IS_PRESENT"] ?? 'No',
      totalPresent: json["TotalPresent"] ?? 0,
      labourCategory: json["LabourCategory"] ?? '',
      totalCount: json["TotalCount"] ?? 0,
      inTime: parsedInTime,
      outTime: parsedOutTime,
      totalHrs: parseToDouble(json["TOTAL_HRS"]) ?? 0.0,
      inPicture: json["IN_PICTURE"],
      outPicture: json["OUT_PICTURE"],
      remark: json["REMARK"],
      overTime: parseToDouble(json["OVER_TIME"]),
     // overTime: json["OVER_TIME"] ?? 0,
      overtimeRate: parseToDouble(json["OVERTIME_RATE"]) ?? 0.0,
      inLatitude: parseToDouble(json["IN_LATITUDE"]),
      inLongitude: parseToDouble(json["IN_LONGITUDE"]),
      outLatitude: parseToDouble(json["OUT_LATITUDE"]),
      outLongitude: parseToDouble(json["OUT_LONGITUDE"]),
      inGeoAddress: json["IN_GEOADDRESS"],
      outGeoAddress: json["OUT_GEOADDRESS"],
      activityName: json["ACTIVITY_NAME"],
      projectItemTypeId: json["PROJECT_ITEM_TYPEID"],
      isApproved: json["IS_APPROVED"],
      isPaid: json["IS_PAID"],
      date: json["DATE"] != null ? DateTime.tryParse(json["DATE"]) : null,
      inDocumentPath: json["IN_PICTURE"],
      outDocumentPath: json["OUT_PICTURE"],
      createdBy: json["CREATED_BY"],
      createdDate: json["CREATED_DATE"] != null ? DateTime.tryParse(json["CREATED_DATE"]) : null,
      lastUpdatedBy: json["LAST_UPDATED_BY"],
      lastUpdatedDate: json["LAST_UPDATED_DATE"] != null ? DateTime.tryParse(json["LAST_UPDATED_DATE"]) : null,
      isDeleted: json["IS_DELETED"],
      approvedBy: json["APPROVED_BY"],
      approvedDate: json["APPROVED_DATE"] != null ? DateTime.tryParse(json["APPROVED_DATE"]) : null,
      status: json["STATUS"],
      contractorId: json["CONTRACTORID"],
      base64Image: json["Base64Image"],
      fileName: json["FileName"],
    );
  }
}

// class LabourAttendance {
//   final int labourId;
//   final int labourAttendanceId;
//   final String labourName;
//   final String contractorName;
//   final String? labourCode;
//   final int plantId;
//   final String isPresent;
//   final int totalPresent;
//   final String labourCategory;
//   final int totalCount;
//   final DateTime? inTime;
//   final DateTime? outTime;
//   final double totalHrs;
//   final String? inPicture;
//   final String? outPicture;
//   final String? remark;
//   final int? overTime;
//   final double? overtimeRate;
//   final double? inLatitude;
//   final double? inLongitude;
//   final double? outLatitude;
//   final double? outLongitude;
//   final String? inGeoAddress;
//   final String? outGeoAddress;
//   final String? activityName;
//   final int? projectItemTypeId;
//   final bool? isApproved;
//   final bool? isPaid;
//
//   final DateTime? date;
//   final String? inDocumentPath;
//   final String? outDocumentPath;
//   final int? createdBy;
//   final DateTime? createdDate;
//   final int? lastUpdatedBy;
//   final DateTime? lastUpdatedDate;
//   final bool? isDeleted;
//   final int? approvedBy;
//   final DateTime? approvedDate;
//   final String? status;
//   final int? contractorId;
//   final String? base64Image;
//   final String? fileName;
//
//   LabourAttendance({
//     required this.labourId,
//     required this.labourAttendanceId,
//     required this.labourName,
//     required this.contractorName,
//     required this.labourCode,
//     required this.plantId,
//     required this.isPresent,
//     required this.totalPresent,
//     required this.labourCategory,
//     required this.totalCount,
//     this.inTime,
//     this.outTime,
//     required this.totalHrs,
//     this.inPicture,
//     this.outPicture,
//     this.remark,
//     this.overTime,
//     this.overtimeRate,
//     this.inLatitude,
//     this.inLongitude,
//     this.outLatitude,
//     this.outLongitude,
//     this.inGeoAddress,
//     this.outGeoAddress,
//     this.activityName,
//     this.projectItemTypeId,
//     this.isApproved,
//     this.isPaid,
//     this.date,
//     this.inDocumentPath,
//     this.outDocumentPath,
//     this.createdBy,
//     this.createdDate,
//     this.lastUpdatedBy,
//     this.lastUpdatedDate,
//     this.isDeleted,
//     this.approvedBy,
//     this.approvedDate,
//     this.status,
//     this.contractorId,
//     this.base64Image,
//     this.fileName,
//   });
//
//   factory LabourAttendance.fromJson(Map<String, dynamic> json) {
//     double? parseToDouble(dynamic value) {
//       if (value == null) return null;
//       if (value is num) return value.toDouble();
//       if (value is String) return double.tryParse(value);
//       return null;
//     }
//
//     return LabourAttendance(
//       labourId: json["LABOUR_ID"] ?? 0,
//       labourAttendanceId: json["LABOUR_ATTENDANCEID"] ?? 0,
//       labourName: json["LabourName"] ?? '',
//       contractorName: json["ContractorName"] ?? '',
//       labourCode: json["LabourCode"],
//       plantId: json["PLANT_ID"] ?? 0,
//       isPresent: json["IS_PRESENT"] ?? 'No',
//       totalPresent: json["TotalPresent"] ?? 0,
//       labourCategory: json["LabourCategory"] ?? '',
//       totalCount: json["TotalCount"] ?? 0,
//       inTime: json["IN_TIME"] != null ? DateTime.tryParse(json["IN_TIME"]) : null,
//       outTime: json["OUT_TIME"] != null ? DateTime.tryParse(json["OUT_TIME"]) : null,
//       totalHrs: parseToDouble(json["TOTAL_HRS"]) ?? 0.0,
//       inPicture: json["IN_PICTURE"],
//       outPicture: json["OUT_PICTURE"],
//       remark: json["REMARK"],
//       overTime: json["OVER_TIME"] ?? 0,
//       overtimeRate: parseToDouble(json["OVERTIME_RATE"]) ?? 0.0,
//       inLatitude: parseToDouble(json["IN_LATITUDE"]),
//       inLongitude: parseToDouble(json["IN_LONGITUDE"]),
//       outLatitude: parseToDouble(json["OUT_LATITUDE"]),
//       outLongitude: parseToDouble(json["OUT_LONGITUDE"]),
//       inGeoAddress: json["IN_GEOADDRESS"],
//       outGeoAddress: json["OUT_GEOADDRESS"],
//       activityName: json["ACTIVITY_NAME"],
//       projectItemTypeId: json["PROJECT_ITEM_TYPEID"],
//       isApproved: json["IS_APPROVED"],
//       isPaid: json["IS_PAID"],
//       date: json["DATE"] != null ? DateTime.tryParse(json["DATE"]) : null,
//       inDocumentPath: json["IN_PICTURE"],
//       outDocumentPath: json["OUT_PICTURE"],
//       createdBy: json["CREATED_BY"],
//       createdDate: json["CREATED_DATE"] != null ? DateTime.tryParse(json["CREATED_DATE"]) : null,
//       lastUpdatedBy: json["LAST_UPDATED_BY"],
//       lastUpdatedDate: json["LAST_UPDATED_DATE"] != null ? DateTime.tryParse(json["LAST_UPDATED_DATE"]) : null,
//       isDeleted: json["IS_DELETED"],
//       approvedBy: json["APPROVED_BY"],
//       approvedDate: json["APPROVED_DATE"] != null ? DateTime.tryParse(json["APPROVED_DATE"]) : null,
//       status: json["STATUS"],
//       contractorId: json["CONTRACTORID"],
//       base64Image: json["Base64Image"],
//       fileName: json["FileName"],
//     );
//   }
// }


enum FormMode { add, edit }


