import 'package:flutter/material.dart';

import 'network/local/cache_helper.dart';

const baseUrl = 'https://fcm.googleapis.com/fcm/';
const backgroundImage =
    'https://image.freepik.com/free-photo/impressed-surprised-man-points-away-blank-space_273609-40694.jpg';
const profileImage =
    'https://image.freepik.com/free-photo/no-problem-concept-bearded-man-makes-okay-gesture-has-everything-control-all-fine-gesture-wears-spectacles-jumper-poses-against-pink-wall-says-i-got-this-guarantees-something_273609-42817.jpg';
const MaterialColor primaryColor = Colors.blue;
const String appToken =
    'key=AAAAbQaVdg4:APA91bG5eAiH8rfCF7S1wycS8su9Zze_L3e03LKNyRgW_4eI-qDSjB6XOjqtioE6XUDVLgDUIWAbWi9rGcn8ZyZfqiTWMLuk2Evez2wsuNvG7PeNW1J_9oOrUzGklsQ2lvAUWJJejPI4';
String? userId;
String? token;
String? lang = CacheHelper.getData(key: 'lang') == null
    ? 'en'
    : CacheHelper.getData(key: 'lang');
