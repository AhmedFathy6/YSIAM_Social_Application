import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/users/user_profile.dart';
import 'package:social_app/shared/build_user.dart';
import 'package:social_app/shared/component.dart';
import 'package:get/get.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class UserNotificationsScreen extends StatelessWidget {
  const UserNotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Component.defaultAppBar(
        context: context,
        beforeGoBack: () {},
        title: Text('Notifications'.tr),
      ),
      body: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => BuildUser.buildUser(
              context: context,
              user: cubit.users.firstWhere(
                (element) =>
                    element.userId ==
                    cubit.currentUser.notifications[index].userId,
              ),
              screen: UserProfileScreen(
                user: cubit.users.firstWhere(
                  (element) =>
                      element.userId ==
                      cubit.currentUser.notifications[index].userId,
                ),
              ),
              isList: false,
              screenEnum: Screen.ViewNotifications,
              notification: cubit.currentUser.notifications[index],
              runFunction: () {
                cubit.currentUser.notifications[index].isRead = true;
                cubit.readNotification(
                    notification: cubit.currentUser.notifications[index]);
              },
            ),
            separatorBuilder: (context, index) =>
                Component.defaultDivider(context: context),
            itemCount: cubit.currentUser.notifications.length,
          );
        },
      ),
    );
  }
}
