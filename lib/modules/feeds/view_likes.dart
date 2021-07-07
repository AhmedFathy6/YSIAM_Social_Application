import 'package:flutter/material.dart';
import 'package:social_app/models/like_post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/users/user_profile.dart';
import 'package:social_app/shared/build_user.dart';
import 'package:social_app/shared/component.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:get/get.dart';

class ViewLikes extends StatelessWidget {
  final List<LikePostModel> likes;
  const ViewLikes({Key? key, required this.likes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<UserModel> userLikes = AppCubit.get(context)
        .users
        .where((element) =>
            likes.where((e) => e.userId == element.userId && e.like).isNotEmpty)
        .toList();

    return Scaffold(
      appBar: Component.defaultAppBar(
        context: context,
        beforeGoBack: () {},
        title: Text('People who liked'.tr),
      ),
      body: ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return BuildUser.buildUser(
              context,
              userLikes[index],
              UserProfileScreen(
                user: userLikes[index],
              ),
              false,
              true);
        },
        separatorBuilder: (context, index) =>
            Component.defaultDivider(context: context),
        itemCount: userLikes.length,
      ),
    );
  }
}
