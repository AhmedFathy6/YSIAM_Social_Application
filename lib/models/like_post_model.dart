class LikePostModel {
  String userId = "";
  bool like = false;

  LikePostModel({
    required this.userId,
    required this.like,
  });

  LikePostModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    like = json['like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['like'] = this.like;
    return data;
  }

  static List<Map<String, dynamic>> getList(List<LikePostModel> likes) {
    final List<Map<String, dynamic>> data = [];
    likes.forEach((element) {
      data.add(element.toJson());
    });
    return data;
  }
}
