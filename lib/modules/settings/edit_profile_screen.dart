import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/component.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    nameController.text = cubit.currentUser.name;
    bioController.text = cubit.currentUser.bio!;
    emailController.text = cubit.currentUser.email;
    phoneController.text = cubit.currentUser.phone;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: Component.defaultAppBar(
            context: context,
            title: Text('Edit Profile'.tr),
            actions: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  end: 7.0,
                ),
                child: Component.defaultTextButton(
                  text: 'UPDATE'.tr,
                  onPressed: () => cubit.updateUserData(
                    user: UserModel(
                      name: nameController.text,
                      phone: phoneController.text,
                      email: emailController.text,
                      bio: bioController.text,
                      userId: userId!,
                      image: cubit.currentUser.image,
                      coverImage: cubit.currentUser.coverImage,
                    ),
                  ),
                ),
              ),
            ],
            beforeGoBack: () {},
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    if (state is LoadingUpdateState) LinearProgressIndicator(),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: Container(
                        height: 180.0,
                        child: Stack(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            defaultStack(
                              onTap: () => cubit.getCoverImage(),
                              cubit: cubit,
                              actions: [
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
                                    child: cubit.imageCover == null
                                        ? Image(
                                            image: NetworkImage(cubit
                                                        .currentUser
                                                        .coverImage !=
                                                    ""
                                                ? cubit.currentUser.coverImage
                                                : backgroundImage),
                                            height: 150.0,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Image(
                                            image: FileImage(cubit.imageCover!),
                                            height: 150.0,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  alignment: Alignment.topCenter,
                                ),
                              ],
                              directional: AlignmentDirectional.topEnd,
                            ),
                            defaultStack(
                              onTap: () => cubit.getProfileImage(),
                              cubit: cubit,
                              actions: [
                                CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  radius: 64.0,
                                  child: cubit.imageProfile == null
                                      ? CircleAvatar(
                                          radius: 60.0,
                                          backgroundImage: NetworkImage(
                                              cubit.currentUser.image != ""
                                                  ? cubit.currentUser.image
                                                  : profileImage),
                                        )
                                      : CircleAvatar(
                                          radius: 60.0,
                                          backgroundImage:
                                              FileImage(cubit.imageProfile!),
                                        ),
                                ),
                              ],
                              directional: AlignmentDirectional.bottomEnd,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Component.defaultTextFormField(
                      controller: nameController,
                      labelText: 'Name'.tr,
                      prefixIcon: IconBroken.User,
                      type: TextInputType.text,
                      borderRadius: 5.0,
                      context: context,
                      validator: (value) {
                        if (value!.isEmpty) return 'Must add name'.tr;
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Component.defaultTextFormField(
                      controller: bioController,
                      labelText: 'Bio'.tr,
                      prefixIcon: IconBroken.Info_Circle,
                      type: TextInputType.emailAddress,
                      borderRadius: 5.0,
                      context: context,
                      validator: (value) {
                        if (value!.isEmpty) return 'Must add Bio'.tr;
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Component.defaultTextFormField(
                      controller: emailController,
                      labelText: 'Email'.tr,
                      prefixIcon: Icons.email_outlined,
                      type: TextInputType.emailAddress,
                      borderRadius: 5.0,
                      context: context,
                      validator: (value) {
                        if (value!.isEmpty) return 'Must add email address'.tr;
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Component.defaultTextFormField(
                      controller: phoneController,
                      labelText: 'Phone'.tr,
                      prefixIcon: IconBroken.Call,
                      type: TextInputType.phone,
                      borderRadius: 5.0,
                      context: context,
                      validator: (value) {
                        if (value!.isEmpty) return 'Must add phone'.tr;
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget defaultStack({
    required AppCubit cubit,
    required List<Widget> actions,
    required AlignmentDirectional directional,
    required VoidCallback? onTap,
  }) {
    actions.add(IconButton(
      onPressed: onTap,
      icon: CircleAvatar(
        child: Icon(
          IconBroken.Camera,
          size: 20.0,
        ),
      ),
    ));
    return Stack(
      alignment: directional,
      children: actions,
    );
  }
}
