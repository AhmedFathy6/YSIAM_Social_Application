import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/chats/chat_screen.dart';
import 'package:social_app/modules/feeds/add_comment.dart';
import 'package:social_app/modules/feeds/view_image_post.dart';
import 'package:social_app/modules/feeds/view_likes.dart';
import 'package:social_app/modules/users/user_profile.dart';
import 'package:social_app/shared/component.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

enum Items { sendMessage, viewAccount, delete }

class BuildPost {
  static Widget buildPostItem({
    required BuildContext context,
    required AppCubit cubit,
    required PostModel post,
  }) =>
      Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 10.0,
        color: cubit.isDark ? HexColor('333739') : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(
                      cubit.currentUser.userId == post.userId
                          ? cubit.currentUser.image
                          : post.userImage != ""
                              ? post.userImage
                              : profileImage,
                    ),
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
                            Text(
                              post.name,
                              style: Theme.of(context).textTheme.bodyText1,
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
                        Text(
                          '${DateFormat.yMMMMEEEEd().format(post.creationDate)} ${DateFormat.jm().format(post.creationDate)}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  buildMenu(post: post, cubit: cubit, context: context),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey[300],
                ),
              ),
              if (post.postText.isNotEmpty)
                Text(
                  post.postText,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 5.0,
                ),
                child: Container(
                  width: double.infinity,
                  // child: Wrap(
                  //   spacing: 4.0,
                  //   children: [
                  //     Container(
                  //       child: MaterialButton(
                  //         onPressed: () {},
                  //         child: Text(
                  //           '#software',
                  //           style:
                  //               Theme.of(context).textTheme.caption!.copyWith(
                  //                     color: primaryColor,
                  //                   ),
                  //         ),
                  //         height: 25.0,
                  //         minWidth: 1.0,
                  //         padding: EdgeInsets.zero,
                  //       ),
                  //       height: 20.0,
                  //     ),
                  //     Container(
                  //       child: MaterialButton(
                  //         onPressed: () {},
                  //         child: Text(
                  //           '#flutter',
                  //           style:
                  //               Theme.of(context).textTheme.caption!.copyWith(
                  //                     color: primaryColor,
                  //                   ),
                  //         ),
                  //         height: 25.0,
                  //         minWidth: 1.0,
                  //         padding: EdgeInsets.zero,
                  //       ),
                  //       height: 20.0,
                  //     ),
                  //     Container(
                  //       child: MaterialButton(
                  //         onPressed: () {},
                  //         child: Text(
                  //           '#developer',
                  //           style:
                  //               Theme.of(context).textTheme.caption!.copyWith(
                  //                     color: primaryColor,
                  //                   ),
                  //         ),
                  //         height: 25.0,
                  //         minWidth: 1.0,
                  //         padding: EdgeInsets.zero,
                  //       ),
                  //       height: 20.0,
                  //     ),
                  //   ],
                  // ),
                ),
              ),
              if (post.postImages.isNotEmpty)
                Container(
                  height: 170.0,
                  width: double.infinity,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                  ),
                  child: Container(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: CarouselSlider(
                        children: post.postImages
                            .map(
                              (e) => InkWell(
                                onTap: () {
                                  Get.to(
                                    () => ViewImagePost(
                                      images: post.postImages,
                                    ),
                                  );
                                },
                                child: Image.network(
                                  e,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                            .toList(),
                        initialPage: 0,
                        unlimitedMode:
                            post.postImages.length > 1 ? true : false,
                        autoSliderTransitionCurve: Curves.fastOutSlowIn,
                        scrollDirection: Axis.horizontal,
                        slideIndicator: post.postImages.length > 1
                            ? CircularWaveSlideIndicator(
                                currentIndicatorColor: primaryColor,
                                indicatorBackgroundColor: Colors.white,
                                indicatorBorderColor: primaryColor,
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                ))
                            : null,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Row(
                          children: [
                            Icon(
                              post.likes
                                      .where((element) =>
                                          element.userId == userId &&
                                          element.like == true)
                                      .isEmpty
                                  ? IconBroken.Heart
                                  : Icons.favorite,
                              size: 17.0,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              post.likes
                                  .where((element) => element.like == true)
                                  .length
                                  .toString(),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        onTap: () {
                          Get.to(() => ViewLikes(
                                likes: post.likes,
                              ));
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              IconBroken.Chat,
                              size: 17.0,
                              color: Colors.yellow,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('${post.comments.length} ' + 'comments'.tr,
                                style: Theme.of(context).textTheme.caption),
                          ],
                        ),
                        onTap: () {
                          AppCubit.get(context).getCommentsToPost(post: post);
                          Get.to(() => AddComments(post: post));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 15.0,
                      backgroundImage: NetworkImage(
                          cubit.currentUser.image != ""
                              ? cubit.currentUser.image
                              : profileImage),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          AppCubit.get(context).getCommentsToPost(post: post);
                          Get.to(() => AddComments(post: post));
                        },
                        child: Text(
                          'write a comment...'.tr,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          Icon(
                            post.likes
                                    .where((element) =>
                                        element.userId == userId &&
                                        element.like == true)
                                    .isEmpty
                                ? IconBroken.Heart
                                : Icons.favorite,
                            size: 17.0,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Like'.tr,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                      onTap: () => cubit.likePosts(post: post),
                    ),
                    SizedBox(
                      width: 25.0,
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Upload,
                            size: 17.0,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Share'.tr,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  static Widget buildMenu(
      {required BuildContext context,
      required AppCubit cubit,
      required PostModel post}) {
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
            cubit.deletePost(post);
            break;
          default:
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Items>>[
        if (post.userId != userId!)
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
        if (post.userId != userId!)
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
        if (post.userId == userId!)
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
