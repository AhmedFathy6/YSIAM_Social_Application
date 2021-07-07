import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'comment_post_model.dart';
import 'like_post_model.dart';

class PostModel {
  String id = Uuid().v1();
  String name = "";
  String userId = "";
  String userImage = "";
  DateTime creationDate = DateTime.now();
  List<String> postImages = [];
  List<LikePostModel> likes = [];
  List<CommentPostModel> comments = [];
  String postText = "";

  PostModel({
    required this.name,
    required this.userId,
    required this.userImage,
    required this.postText,
  });

  PostModel.fromJson(
      {required Map<String, dynamic> json,
      QueryDocumentSnapshot<Map<String, dynamic>>? element}) {
    id = json['id'];
    name = json['name'];
    userId = json['userId'];
    userImage = json['userImage'];
    postText = json['postText'];
    creationDate = DateTime.fromMillisecondsSinceEpoch(
        json['creationDate'].millisecondsSinceEpoch);
    if (json['postImages'] != null) {
      json['postImages'].forEach((v) {
        postImages.add(v);
      });
    }
    if (element != null) {}
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['userId'] = this.userId;
    data['userImage'] = this.userImage;
    data['postImages'] = this.postImages;
    data['likes'] = LikePostModel.getList(this.likes);
    data['postText'] = this.postText;
    data['creationDate'] = creationDate;
    return data;
  }

  static List<PostModel> getList(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> json) {
    List<PostModel> posts = [];
    json.forEach((element) {
      posts.add(PostModel.fromJson(json: element.data(), element: element));
    });
    return posts;
  }
}
