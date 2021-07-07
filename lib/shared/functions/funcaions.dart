import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import '../component.dart';
import '../constants.dart';
import '../network/local/cache_helper.dart';
import 'package:get/get.dart';

class PublicFunctions {
  void loginSuccess({required BuildContext context, required String uId}) {
    Component.buildAlert(
      context: context,
      title: 'Login Success',
      body: 'Welcome'.tr,
      dialogType: DialogType.SUCCES,
      hideAfter: Duration(
        seconds: 5,
      ),
    )..show().then(
        (value) {
          CacheHelper.saveData(key: 'userId', value: uId).then(
            (value) {
              userId = uId;
              FirebaseMessaging.instance.getToken().then(
                (value) {
                  token = value;
                  CacheHelper.saveData(key: 'isLoginBefore', value: true).then(
                    (value) => Component.navigateAndFinish(
                      context,
                      HomeLayout(),
                    ),
                  );
                },
              );
            },
          );
        },
      );
  }

  void loginError({required BuildContext context, required String error}) {
    Component.buildAlert(
      context: context,
      title: 'Login Failed',
      body: error,
      dialogType: DialogType.ERROR,
      hideAfter: Duration(
        seconds: 5,
      ),
    )..show();
  }

  void logOut({required BuildContext context}) {
    CacheHelper.clearData(key: 'userId').then(
      (value) {
        if (value) {
          userId = null;
          CacheHelper.clearData(key: 'isLoginBefore');
          Component.navigateAndFinish(
            context,
            LoginScreen(),
          );
        }
      },
    );
  }
}
