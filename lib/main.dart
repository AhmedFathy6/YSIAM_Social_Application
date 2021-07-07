import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/cubit/bloc_observer.dart';
import 'modules/chats/chat_screen.dart';
import 'modules/home/main_app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'shared/cubit/cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        enableLights: true,
        enableVibration: true,
        playSound: true,
        ledColor: Colors.white,
      ),
    ],
  );

  AwesomeNotifications().actionStream.listen(
    (receivedNotification) {
      if (receivedNotification.id == 1) {
        if (receivedNotification.payload!['type'] == 'user') {
          Get.to(
            ChatScreen(
              user: UserModel.fromJson(
                  json.decode(receivedNotification.payload!['user']!)),
            ),
          );
        }
      }
    },
  );

  FirebaseMessaging.onMessage.listen((message) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        body: message.notification!.body,
        backgroundColor: AppCubit().isDark ? HexColor('333739') : Colors.white,
        title: message.notification!.title,
        id: 1,
        displayOnForeground: true,
        bigPicture: message.notification!.android!.imageUrl,
        channelKey: 'basic_channel',
        largeIcon: message.notification!.android!.imageUrl,
        showWhen: true,
        payload: message.data.cast(),
      ),
    );
  }).onError((error) {
    print('Error');
  });

  FirebaseMessaging.onMessageOpenedApp.listen(
    (message) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          body: message.notification!.body,
          backgroundColor:
              AppCubit().isDark ? HexColor('333739') : Colors.white,
          title: message.notification!.title,
          id: 1,
          displayOnForeground: true,
          bigPicture: message.notification!.android!.imageUrl,
          channelKey: 'basic_channel',
          largeIcon: message.notification!.android!.imageUrl,
          showWhen: true,
          payload: message.data.cast(),
        ),
      );
    },
  ).onError(
    (error) {
      print('Error');
    },
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  userId = CacheHelper.getData(key: 'userId');
  lang = CacheHelper.getData(key: 'lang') == null ? 'en' : 'ar';
  runApp(MainMaterial());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");

  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel for basic tests',
      defaultColor: Color(0xFF9D50DD),
      enableLights: true,
      enableVibration: true,
      playSound: true,
      ledColor: Colors.white,
    ),
  ]);

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      body: message.notification!.body,
      backgroundColor: AppCubit().isDark ? HexColor('333739') : Colors.white,
      title: message.notification!.title,
      id: 1,
      displayOnForeground: true,
      bigPicture: message.notification!.android!.imageUrl,
      channelKey: 'basic_channel',
      largeIcon: message.notification!.android!.imageUrl,
      showWhen: true,
      payload: message.data.cast(),
    ),
  );
}
