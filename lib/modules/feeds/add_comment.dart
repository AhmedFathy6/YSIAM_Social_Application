import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/post/post_layout.dart';
import 'package:social_app/models/comment_post_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chat_screen.dart';
import 'package:social_app/modules/users/user_profile.dart';
import 'package:social_app/shared/component.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class AddComments extends StatelessWidget {
  final PostModel post;
  const AddComments({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    post.comments.sort((a, b) => a.commentDate.compareTo(b.commentDate));
    final commentController = TextEditingController();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: Component.defaultAppBar(
            context: context,
            beforeGoBack: () {},
            title: Text('People who commented'.tr),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      UserModel user = post.comments.isNotEmpty
                          ? cubit.users
                              .where((element) =>
                                  post.comments[index].userId == element.userId)
                              .toList()
                              .first
                          : UserModel.emptyObject();
                      return Column(
                        children: [
                          Align(
                            widthFactor: 1,
                            alignment: AlignmentDirectional.bottomStart,
                            child: Text(
                              '${DateFormat.yMMMd().format(post.comments[index].commentDate)} ${DateFormat.jm().format(post.comments[index].commentDate)}',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: cubit.isDark
                                  ? Colors.grey[700]
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25.0,
                                  backgroundImage: NetworkImage(user.image),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        post.comments[index].comment,
                                      ),
                                    ],
                                  ),
                                ),
                                buildMenu(
                                  context: context,
                                  cubit: cubit,
                                  comment: post.comments[index],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 10.0),
                    itemCount: post.comments.length,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Component.defaultTextFormField(
                  controller: commentController,
                  labelText: 'write a comment',
                  prefixIcon: Icons.comment,
                  suffixIcon: IconBroken.Send,
                  type: TextInputType.text,
                  labelStyle: Theme.of(context).textTheme.caption,
                  context: context,
                  validator: (value) {},
                  suffixPressed: () {
                    cubit.commentPost(
                        post: post, commentText: commentController.text);
                    commentController.text = '';
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildMenu(
      {required BuildContext context,
      required AppCubit cubit,
      required CommentPostModel comment}) {
    return PopupMenuButton<Items>(
      color: cubit.isDark ? HexColor('333739') : Colors.white,
      onSelected: (Items result) {
        switch (result) {
          case Items.sendMessage:
            Component.navigateTo(
              context,
              ChatScreen(
                user: cubit.users
                    .firstWhere((element) => element.userId == post.userId),
              ),
            );
            break;
          case Items.viewAccount:
            cubit.getUserPostsData(post.userId, false);
            Component.navigateTo(
              context,
              UserProfileScreen(
                user: cubit.users
                    .firstWhere((element) => element.userId == post.userId),
              ),
            );
            break;
          case Items.delete:
            cubit.deleteComment(post, comment);
            break;
          default:
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Items>>[
        if (comment.userId != userId!)
          PopupMenuItem<Items>(
            value: Items.sendMessage,
            child: Row(
              children: [
                Icon(IconBroken.Chat),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  'Send Message'.tr,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        if (comment.userId != userId!)
          PopupMenuItem<Items>(
            value: Items.viewAccount,
            child: Row(
              children: [
                Icon(IconBroken.User),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  'View'.tr,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        if (comment.userId == userId!)
          PopupMenuItem<Items>(
            value: Items.delete,
            child: Row(
              children: [
                Icon(IconBroken.Delete),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  'Delete'.tr,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
