import 'package:uuid/uuid.dart';

class CommentPostModel {
  String id = Uuid().v1();
  String userId = "";
  String comment = "";
  DateTime commentDate = DateTime.now();

  CommentPostModel({
    required this.userId,
    required this.comment,
  });

  CommentPostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    comment = json['comment'];
    commentDate = DateTime.fromMillisecondsSinceEpoch(
        json['commentDate'].millisecondsSinceEpoch);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['comment'] = this.comment;
    data['commentDate'] = this.commentDate;
    return data;
  }

  static List<Map<String, dynamic>> getList(List<CommentPostModel> likes) {
    final List<Map<String, dynamic>> data = [];
    likes.forEach((element) {
      data.add(element.toJson());
    });
    return data;
  }
}
