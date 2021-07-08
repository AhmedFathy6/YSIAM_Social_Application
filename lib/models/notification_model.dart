import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class NotificationModel {
  String id = Uuid().v1();
  String body = "";
  String title = "";
  DateTime creationDate = DateTime.now();
  String image = "";
  String userId = "";
  bool isRead = false;

  NotificationModel({
    required this.body,
    required this.title,
    required this.image,
    required this.userId,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    body = json['body'];
    title = json['title'];
    image = json['image'];
    userId = json['userId'];
    isRead = json['isRead'];
    creationDate = DateTime.fromMillisecondsSinceEpoch(
        json['creationDate'].millisecondsSinceEpoch);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['body'] = this.body;
    data['title'] = this.title;
    data['image'] = this.image;
    data['userId'] = this.userId;
    data['isRead'] = this.isRead;
    data['creationDate'] = this.creationDate;
    return data;
  }

  static List<NotificationModel> getList(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> json) {
    List<NotificationModel> messages = [];
    json.forEach((element) {
      messages.add(NotificationModel.fromJson(element.data()));
    });
    return messages;
  }
}
