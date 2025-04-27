class PostApiModel {
  int? id;
  String? token;

  PostApiModel({this.id, this.token});

  // Factory constructor for creating an instance from a JSON map
  factory PostApiModel.fromJson(Map<String, dynamic> json) {
    return PostApiModel(
      id: json['id'],
      token: json['token'],
    );
  }

  // Method to convert the instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token': token,
    };
  }
}
