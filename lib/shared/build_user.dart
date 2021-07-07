import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/users/user_profile.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'component.dart';
import 'constants.dart';
import 'package:dotted_border/dotted_border.dart';

class BuildUser {
  static Widget buildUser(
          BuildContext context, UserModel user, Widget screen, bool isList,
          [bool isViewLikes = false]) =>
      InkWell(
        onTap: () {
          if (screen is UserProfileScreen)
            AppCubit.get(context).getUserPostsData(user.userId, false);
          Component.navigateTo(
            context,
            screen,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isViewLikes
              ? BuildUser().buildUserLikeRow(context, user)
              : BuildUser().buildUserRow(context, user, isList),
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
}
