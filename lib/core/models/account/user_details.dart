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
