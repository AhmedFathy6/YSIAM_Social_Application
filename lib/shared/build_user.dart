import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_app/models/notification_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/users/user_profile.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'component.dart';
import 'constants.dart';
import 'package:dotted_border/dotted_border.dart';

enum Screen { UserProfile, ViewLikes, ViewNotifications }

class BuildUser {
  static Widget buildUser({
    required BuildContext context,
    required UserModel user,
    required Widget screen,
    required bool isList,
    Screen screenEnum = Screen.UserProfile,
    NotificationModel? notification,
    VoidCallback? runFunction,
  }) =>
      InkWell(
        onTap: () {
          if (runFunction != null) runFunction.call();
          if (screen is UserProfileScreen)
            AppCubit.get(context).getUserPostsData(user.userId, false);
          Component.navigateTo(
            context,
            screen,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BuildUser.chooseScreen(
            context: context,
            user: user,
            screen: screenEnum,
            isList: isList,
            notification: notification == null
                ? NotificationModel(
                    userId: "",
                    image: "",
                    body: "",
                    title: "",
                  )
                : notification,
          ),
        ),
      );

  Widget buildUserRow(BuildContext context, UserModel user, bool isList) => Row(
        children: [
          DottedBorder(
            color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
            dashPattern: [8, 4],
            strokeWidth: 2,
            borderType: BorderType.Circle,
            child: CircleAvatar(
              radius: 25.0,
              backgroundImage:
                  NetworkImage(user.image != "" ? user.image : profileImage),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Row(
              children: [
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.subtitle2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                  size: 17.0,
                ),
              ],
            ),
          ),
          if (isList)
            Icon(
              IconBroken.Arrow___Right_2,
            ),
        ],
      );

  Widget buildUserLikeRow(BuildContext context, UserModel user) => Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage:
                NetworkImage(user.image != "" ? user.image : profileImage),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Text(
              user.name,
              style: Theme.of(context).textTheme.subtitle2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ],
      );

  Widget buildUserNotificationRow(
          BuildContext context, NotificationModel notification) =>
      Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
                notification.image != "" ? notification.image : profileImage),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (!notification.isRead)
                      CircleAvatar(
                        radius: 5.0,
                        backgroundColor: Colors.green,
                      ),
                    if (!notification.isRead)
                      SizedBox(
                        width: 5.0,
                      ),
                    Text(
                      notification.title,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  notification.body,
                  style: Theme.of(context).textTheme.subtitle2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  '${DateFormat.yMMMd().format(notification.creationDate)} ${DateFormat.jm().format(notification.creationDate)}',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        ],
      );

  static Widget chooseScreen(
      {required Screen screen,
      required BuildContext context,
      required UserModel user,
      required bool isList,
      NotificationModel? notification}) {
    switch (screen) {
      case Screen.UserProfile:
        return BuildUser().buildUserRow(context, user, isList);

      case Screen.ViewLikes:
        return BuildUser().buildUserLikeRow(context, user);

      case Screen.ViewNotifications:
        return BuildUser().buildUserNotificationRow(context, notification!);

      default:
        return BuildUser().buildUserRow(context, user, isList);
    }
  }
}
