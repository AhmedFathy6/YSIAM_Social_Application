import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/shared/component.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        var postController = TextEditingController();
        return Scaffold(
          appBar: Component.defaultAppBar(
              context: context,
              title: Text('Create Post'.tr),
              actions: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    end: 7.0,
                  ),
                  child: Component.defaultTextButton(
                    text: 'post'.tr,
                    onPressed: () {
                      cubit
                        ..uploadPost(
                          post: PostModel(
                            name: cubit.currentUser.name,
                            userId: cubit.currentUser.userId,
                            userImage: cubit.currentUser.image,
                            postText: postController.text,
                          ),
                        );
                      //cubit.getAllPostsData();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
              beforeGoBack: () {
                cubit.clearImages();
              }),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(
                          cubit.currentUser.image != ""
                              ? cubit.currentUser.image
                              : profileImage),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                cubit.currentUser.name,
                                style: Theme.of(context).textTheme.bodyText1,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                            ],
                          ),
                          Text(
                            'Public'.tr,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Expanded(
                  child: Component.defaultTextFormField(
                      controller: postController,
                      labelText: 'what is in you mind,'.tr +
                          ' ${cubit.currentUser.name} ',
                      hideBorder: true,
                      isExpanded: true,
                      prefixIcon: null,
                      type: TextInputType.multiline,
                      validator: (value) {},
                      style: TextStyle(
                          color: AppCubit.get(context).isDark
                              ? Colors.white
                              : Colors.black),
                      labelStyle: Theme.of(context).textTheme.caption),
                ),
                if (cubit.postImages.isNotEmpty)
                  Container(
                    height: 250,
                    width: double.infinity,
                    child: GridView.count(
                      physics: BouncingScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: .1,
                      crossAxisSpacing: .1,
                      children: cubit.postImages
                          .map(
                            (e) => Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Card(
                                  child: Image(
                                    image: FileImage(File(e.path)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => cubit.removePostImage(e),
                                  icon: FaIcon(
                                    Icons.cancel,
                                    size: 25,
                                  ),
                                )
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Image,
                            color: primaryColor,
                          ),
                          Component.defaultTextButton(
                              isUpperCase: false,
                              text: 'add photos'.tr,
                              onPressed: () =>
                                  Component.getImageAsBytes().then((value) {
                                    cubit.addImages(value.values.elementAt(0)!);
                                  })),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                    Expanded(
                      child: Component.defaultTextButton(
                          isUpperCase: false,
                          text: '#tags'.tr,
                          onPressed: () {}),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
