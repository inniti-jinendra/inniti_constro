class UserAuthenticationViewModel {
  final String userId;
  final String emailId;
  final String mobileNo;
  final String activeProjectId;
  final String companyCode;
  final String otp;
  final bool authorizedUser;

  UserAuthenticationViewModel({
    required this.userId,
    required this.emailId,
    required this.mobileNo,
    required this.activeProjectId,
    required this.companyCode,
    required this.otp,
    required this.authorizedUser,
  });

  factory UserAuthenticationViewModel.fromJson(Map<String, dynamic> json) {
    return UserAuthenticationViewModel(
      authorizedUser: json['AuthorizedUser'],
      userId: json['UserID'],
      emailId: json['EmailID'],
      mobileNo: json['MobileNo'],
      activeProjectId: json['ActiveProjectID'],
      companyCode: json['CompanyCode'],
      otp: json['OTP'],
    );
  }
}
