/// Centralized API endpoints for better management and consistency
class ApiEndpoints {
 // static const String baseUrl = "http://192.168.1.13:1015/api";  // ✅ Correct IP
  static const String baseUrl = "http://13.233.153.154:2155/api";  // ✅ Correct IP

  /// Authentication Endpoints
  static const String verifyCompany = "$baseUrl/UserAuthentication/Verify-Company";
  static const String generateOtp = "$baseUrl/UserAuthentication/Generate-OTP";

  /// Labour Master Endpoints
  /// Fetch-All-Labours
  static const String fetchAllLabours = "$baseUrl/Labour/Fetch-All-Labours";
  ///Add New Labour or Save
  static const String addLabour = "$baseUrl/Labour/Add-Labour";
  /// Edit-Labour
  static const String editLabour = "$baseUrl/Labour/Edit-Labour";
  /// Delete Labour
  static const String deleteLabour = "$baseUrl/Labour/Delete-Labour";
  /// Get Labour Data
  static const String getLabourData = "$baseUrl/Labour/Get-Labour-Data";

  /// Dropdown Endpoints
  static const String fetchContractorsDDL = "$baseUrl/DropDownHendler/Fetch-Contractors-DDL";
  static const String fetchLabourCategoriesDDL = "$baseUrl/DropDownHendler/Fetch-LabourCategory-DDL";
  static const String fetchProjectItemTypeDDL = "$baseUrl/DropDownHendler/Fetch-ProjectItemType-DDL";
  static const String fetchProjectDDL = "$baseUrl/DropDownHendler/Fetch-Project-DDL";


  /// Labour Attendance Endpoints
  /// Fetch-All-LabourAttendance
  static const String fetchAllLabourAttendance = "$baseUrl/LabourAttendance/Fetch-All-LabourAttendance";
  /// Add Labour Attendance
  static const String addLabourAttendance = "$baseUrl/LabourAttendance/Add-LabourAttendance";
  /// Fetch Labour Attendance Add
  static const String fetchLabourAttendanceAdd = "$baseUrl/LabourAttendance/Fetch-LabourAttendance-Add";
  /// Get Labour Attendance Data
  static const String getLabourAttendanceData = "$baseUrl/LabourAttendance/Get-LabourAttendance-Data";
  /// Edit Labour Attendance
  static const String editLabourAttendance = "$baseUrl/LabourAttendance/Edit-LabourAttendance";

  /// Self Attendance Endpoints
  /// Fetch Self Attendance Data
  static const String fetchSelfAttendanceData = "$baseUrl/SelfAttendance/Fetch-SeltAttendance-Data";
  /// Save Self Attendance
  static const String saveSelfAttendance = "$baseUrl/SelfAttendance/Save-Self-Attendance";

  /// Self Only Attendance Endpoints
  /// Fetch Only Self Attendance Details Data
  static const String fetchOnlySelfAttendanceData = "$baseUrl/AttendanceOnly/Fetch-AttendanceOnly-Details";
 /// Fetch Only Self Attendance Details Data
  static const String fetchOnlySelfAttendanceListData = "$baseUrl/AttendanceOnly/Fetch-AttendanceOnly-List";

  /// Fetch User Profile Account Details Data
  static const String fetchUserAccountDetails = "$baseUrl/UserProfile/Get-UserProfile-Data";


  /// Fuel Purchase
  /// Fetch Fuel Purchase List
  static const String fetchFuelPurchaseList = "$baseUrl/FuelPurchase/Fetch-All-FuelPurchase";

  /// Add Fuel Purchase
  static const String addFuelPurchase = "$baseUrl/FuelPurchase/FuelPurchase-Add";

  /// Fetch Edit Get Data For Fuel Purchase
  static const String fetchEditFuelPurchaseData = "$baseUrl/FuelPurchase/Get-FuelPurchase-Data";

  /// Edit Fuel Purchase
  static const String editFuelPurchase = "$baseUrl/FuelPurchase/Edit-FuelPurchase";

  /// Delete Fuel Purchase
  static const String deleteFuelPurchase = "$baseUrl/FuelPurchase/Delete-FuelPurchase";

}
