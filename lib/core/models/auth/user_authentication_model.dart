class UserAuthenticationModel {
  final String userId;
  final String email;
  final String mobile;
  final String fullName;
  final String activeProjectId;
  final String token;
  final String generatedOtp;

  // ✅ Computed Property to check if the user is authorized
  bool get authorizedUser => userId.isNotEmpty;

  UserAuthenticationModel({
    required this.userId,
    required this.email,
    required this.mobile,
    required this.fullName,
    required this.activeProjectId,
    required this.token,
    required this.generatedOtp,
  });

  // ✅ Convert JSON response to Model
  factory UserAuthenticationModel.fromJson(Map<String, dynamic> json) {
    return UserAuthenticationModel(
      userId: json['UserID'] ?? '',
      email: json['EmailID'] ?? '',
      mobile: json['MobileNo'] ?? '',
      fullName: json['UserFullName'] ?? '',
      activeProjectId: json['ActiveProjectID'] ?? '',
      token: json['GeneratedToken'] ?? '',
      generatedOtp: json['GeneratedOtp'] ?? '',
    );
  }

  // ✅ Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      "UserID": userId,
      "EmailID": email,
      "MobileNo": mobile,
      "UserFullName": fullName,
      "ActiveProjectID": activeProjectId,
      "GeneratedToken": token,
      "GeneratedOtp": generatedOtp,
    };
  }
}
