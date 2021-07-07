import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name = "";
  String phone = "";
  String email = "";
  String userId = "";
  String image = "";
  String coverImage = "";
  String? bio = "";
  String token = "";
  bool? isEmailVerified = false;

  UserModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.userId,
    required this.image,
    required this.coverImage,
    this.bio,
    this.isEmailVerified,
  });

  UserModel.emptyObject();

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    userId = json['userId'];
    image = json['image'];
    coverImage = json['coverImage'];
    bio = json['bio'];
    isEmailVerified = json['isEmailVerified'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['userId'] = this.userId;
    data['image'] = this.image;
    data['bio'] = this.bio;
    data['coverImage'] = coverImage;
    data['isEmailVerified'] = isEmailVerified;
    data['token'] = token;
    return data;
  }

  static List<UserModel> getList(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> json) {
    List<UserModel> users = [];
    json.forEach((element) {
      users.add(UserModel.fromJson(element.data()));
    });
    return users;
  }
}
