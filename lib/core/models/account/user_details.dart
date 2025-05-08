class UserDetails {
  int userId;
  String userName;
  String profilePhotoUrl;
  String emailId;
  String address;
  String adharNumber;
  String panNumber;
  String pfNumber;
  String esicNumber;
  String mobileNo;

  UserDetails({
    required this.userId,
    required this.userName,
    required this.profilePhotoUrl,
    required this.emailId,
    required this.address,
    required this.adharNumber,
    required this.panNumber,
    required this.pfNumber,
    required this.esicNumber,
    required this.mobileNo,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        userId: json["UserID"],
        userName: json["UserName"],
        profilePhotoUrl: json["ProfilePhotoUrl"],
        emailId: json["EmailID"],
        address: json["Address"],
        adharNumber: json["AdharNumber"],
        panNumber: json["PanNumber"],
        pfNumber: json["PFNumber"],
        esicNumber: json["ESICNumber"],
        mobileNo: json["MobileNo"],
      );
}

class ProfileUserDetails {
  final int userID;
  final String userName;
  final String profilePhotoUrl;
  final String emailID;
  final String mobileNo;
  final int employeeCode;
  final String address;
  final String city;
  final String pinCode;
  final String state;
  final String adharNumber;
  final String panNumber;
  final String pfNumber;
  final String esicNumber;
  final int leaveBalance;
  final int totalLeave;
  final String appRoll;

  ProfileUserDetails({
    required this.userID,
    required this.userName,
    required this.profilePhotoUrl,
    required this.emailID,
    required this.mobileNo,
    required this.employeeCode,
    required this.address,
    required this.city,
    required this.pinCode,
    required this.state,
    required this.adharNumber,
    required this.panNumber,
    required this.pfNumber,
    required this.esicNumber,
    required this.leaveBalance,
    required this.totalLeave,
    required this.appRoll,
  });

  factory ProfileUserDetails.fromJson(Map<String, dynamic> json) {
    return ProfileUserDetails(
      userID: json['UserID'] ?? 0,
      userName: json['UserName'] ?? '',
      profilePhotoUrl: json['ProfilePhotoUrl'] ?? '',
      emailID: json['EmailID'] ?? '',
      mobileNo: json['MobileNo'] ?? '',
      employeeCode: json['EmployeeCode'] ?? 0,
      address: json['Address'] ?? '',
      city: json['city'] ?? '',
      pinCode: json['PinCode'] ?? '',
      state: json['State'] ?? '',
      adharNumber: json['AdharNumber'] ?? '',
      panNumber: json['PanNumber'] ?? '',
      pfNumber: json['PFNumber'] ?? '',
      esicNumber: json['ESICNumber'] ?? '',
      leaveBalance: json['LeaveBalance'] ?? 0,
      totalLeave: json['TotalLeave'] ?? 0,
      appRoll: json['AppRoll'] ?? '',
    );
  }
}
