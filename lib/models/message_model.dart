import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class MessageModel {
  String id = Uuid().v1();
  String senderId = "";
  String receiverId = "";
  DateTime creationDate = DateTime.now();
  String text = "";

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    text = json['text'];
    creationDate = DateTime.fromMillisecondsSinceEpoch(
        json['creationDate'].millisecondsSinceEpoch);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['senderId'] = this.senderId;
    data['receiverId'] = this.receiverId;
    data['text'] = this.text;
    data['creationDate'] = this.creationDate;
    return data;
  }

  static List<MessageModel> getList(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> json) {
    List<MessageModel> messages = [];
    json.forEach((element) {
      messages.add(MessageModel.fromJson(element.data()));
    });
    return messages;
  }
}
