import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/layout/post/post_layout.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/settings/edit_profile_screen.dart';
import 'package:social_app/shared/component.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:get/get.dart';

class DefaultUserScreen extends StatelessWidget {
  final UserModel user;
  final List<PostModel> posts;
  const DefaultUserScreen({Key? key, required this.user, required this.posts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        var postCount = cubit.allPosts
            .where((element) => element.userId == user.userId)
            .length;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Container(
                    height: 180.0,
                    child: Stack(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          child: Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  10.0,
                                ),
                                topRight: Radius.circular(
                                  10.0,
                                ),
                              ),
                            ),
                            child: Image(
                              image: NetworkImage(user.coverImage != ""
                                  ? user.coverImage
                                  : backgroundImage),
                              height: 150.0,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          alignment: Alignment.topCenter,
                        ),
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          radius: 64.0,
                          child: CircleAvatar(
                            radius: 60.0,
                            backgroundImage: NetworkImage(
                                user.image != "" ? user.image : profileImage),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  user.bio!,
                  style: Theme.of(context).textTheme.caption,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '$postCount',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            Text(
                              postCount == 1 ? 'Post'.tr : 'Posts'.tr,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '2',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            Text(
                              'Photos'.tr,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '120',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            Text(
                              'Followers'.tr,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '76',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            Text(
                              'Following'.tr,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (user.userId == cubit.currentUser.userId)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              child: Text('Add Photos'.tr),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          OutlinedButton(
                            child: Icon(
                              IconBroken.Edit,
                            ),
                            onPressed: () => Component.navigateTo(
                                context, EditProfileScreen()),
                          ),
                        ],
                      ),
                      height: 40.0,
                    ),
                  ),
                if (posts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Column(
                      children: [
                        state is LoadingGetUserPostsState
                            ? CircularProgressIndicator()
                            : FaIcon(
                                FontAwesomeIcons.camera,
                                size: 50.0,
                              ),
                        Text(
                          state is LoadingGetUserPostsState
                              ? ''
                              : 'No posts yet'.tr,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => BuildPost.buildPostItem(
                    context: context,
                    cubit: cubit,
                    post: posts[index],
                  ),
                  itemCount: posts.length,
                ),
                Container(
                  height: 85,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
