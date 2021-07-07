import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/network/remote/dio_helper.dart';

import '../post_model.dart';

/// to : "fm2CZZeAT5CP3bzOaWBKSt:APA91bFZysYVubuR0grne1q_yWOl7JRgiK-TvHGSctIfAscDqpwoqljWCvrkVJe4EHj6cj1hELXmqFsziJUUEiPYDu9qkLFcW1ltnOW0lYGIo7D5qkzdgumRBuKV8oiIDm7_t9yiExLf"
/// notification : {"title":"Test","body":"Test notification","sound":"default","image":"https://thetruthwire.com/wp-content/uploads/2021/02/Animefrenzy.jpg"}
/// android : {"priority":"HIGH","notification":{"notification_priority":"PRIORITY_MAX","sound":"default","default_sound":true,"default_vibrate_timings":true,"default_light_settings":true},"data":{"type":"order","id":"87","click_action":"FLUTTER_NOTIFICATION_CLICK"}}

class Notify {
  String? to;
  Notification? notification;
  Android? android;
  Data? data = Data();

  Notify({this.to, this.notification, this.android, this.data});

  Notify.fromJson(dynamic json) {
    to = json["to"];
    notification = json["notification"] != null
        ? Notification.fromJson(json["notification"])
        : null;
    android =
        json["android"] != null ? Android.fromJson(json["android"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["to"] = to;
    if (notification != null) {
      map["notification"] = notification?.toJson();
    }
    if (android != null) {
      map["android"] = android?.toJson();
    }
    if (data != null) {
      map["data"] = data?.toJson();
    }
    return map;
  }

  void sendNotification() {
    DioHelper dio = DioHelper();
    dio
        .postData(url: 'send', data: this.toJson())
        .then((value) => print(value.data))
        .onError((error, stackTrace) {
      print(error);
      print(stackTrace);
    });
  }
}

/// priority : "HIGH"
/// notification : {"notification_priority":"PRIORITY_MAX","sound":"default","default_sound":true,"default_vibrate_timings":true,"default_light_settings":true}
/// data : {"type":"order","id":"87","click_action":"FLUTTER_NOTIFICATION_CLICK"}

class Android {
  String? priority = 'HIGH';
  AndroidNotification? notification = AndroidNotification();
  Data? data = Data();

  Android({this.priority, this.notification, this.data});

  Android.fromJson(dynamic json) {
    priority = json["priority"];
    notification = json["notification"] != null
        ? AndroidNotification.fromJson(json["notification"])
        : null;
    data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["priority"] = priority;
    if (notification != null) {
      map["notification"] = notification?.toJson();
    }
    if (data != null) {
      map["data"] = data?.toJson();
    }
    return map;
  }
}

/// type : "order"
/// id : "87"
/// click_action : "FLUTTER_NOTIFICATION_CLICK"

class Data {
  String? type = 'user';
  String? id = '87';
  UserModel? user = UserModel.emptyObject();
  PostModel? post;
  String? clickAction = 'FLUTTER_NOTIFICATION_CLICK';

  Data({this.type, this.id, this.clickAction, this.user, this.post});

  Data.fromJson(dynamic json) {
    type = json["type"];
    id = json["id"];
    clickAction = json["click_action"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["type"] = type;
    map["id"] = id;
    if (post != null) map["post"] = post!.toJson();
    map["user"] = user!.toJson();
    map["click_action"] = clickAction;
    return map;
  }
}

/// notification_priority : "PRIORITY_MAX"
/// sound : "default"
/// default_sound : true
/// default_vibrate_timings : true
/// default_light_settings : true

class AndroidNotification {
  String? notificationPriority = 'PRIORITY_MAX';
  String? sound = 'default';
  bool? defaultSound = true;
  bool? defaultVibrateTimings = true;
  bool? defaultLightSettings = true;

  AndroidNotification(
      {this.notificationPriority,
      this.sound,
      this.defaultSound,
      this.defaultVibrateTimings,
      this.defaultLightSettings});

  AndroidNotification.fromJson(dynamic json) {
    notificationPriority = json["notification_priority"];
    sound = json["sound"];
    defaultSound = json["default_sound"];
    defaultVibrateTimings = json["default_vibrate_timings"];
    defaultLightSettings = json["default_light_settings"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["notification_priority"] = notificationPriority;
    map["sound"] = sound;
    map["default_sound"] = defaultSound;
    map["default_vibrate_timings"] = defaultVibrateTimings;
    map["default_light_settings"] = defaultLightSettings;
    return map;
  }
}

/// title : "Test"
/// body : "Test notification"
/// sound : "default"
/// image : "https://thetruthwire.com/wp-content/uploads/2021/02/Animefrenzy.jpg"

class Notification {
  String? title;
  String? body;
  String sound = 'default';
  String? image;

  Notification({this.title, this.body, this.image});

  Notification.fromJson(dynamic json) {
    title = json["title"];
    body = json["body"];
    sound = json["sound"];
    image = json["image"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = title;
    map["body"] = body;
    map["sound"] = sound;
    map["image"] = image;
    return map;
  }
}
