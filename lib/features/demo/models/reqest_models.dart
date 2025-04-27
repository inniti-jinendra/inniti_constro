class ReqModel {
  String? email;
  String? password;

  // Constructor
  ReqModel({this.email, this.password});

  // From JSON
  ReqModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
  }

  // To JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}
