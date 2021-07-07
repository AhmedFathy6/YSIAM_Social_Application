import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/component.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/functions/funcaions.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:get/get.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return SafeArea(
          child: Container(
            width: 200.0,
            color: !cubit.isDark ? Colors.grey.shade100 : Colors.grey.shade700,
            padding: const EdgeInsetsDirectional.all(
              8.0,
            ),
            child: Column(
              children: [
                Expanded(
                  child: DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(
                            cubit.currentUser.image,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          cubit.currentUser.name,
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Colors.orange,
                                  ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(cubit.currentUser.bio!,
                            style: Theme.of(context).textTheme.caption),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(cubit.currentUser.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption),
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              defualtLitTale(
                                  title: 'Notification'.tr,
                                  icon: IconBroken.Notification,
                                  cubit: cubit,
                                  context: context,
                                  onClick: () {}),
                              Component.defaultDivider(
                                context: context,
                                endIndent: 0.0,
                                indent: 0.0,
                              ),
                              defualtLitTale(
                                title: cubit.lang == 'en' ? 'عربي' : 'English',
                                icon: Icons.language,
                                cubit: cubit,
                                context: context,
                                onClick: () {
                                  cubit.changeLanguage(
                                      cubit.lang == 'en' ? 'ar' : 'en',
                                      context);
                                },
                              ),
                              Component.defaultDivider(
                                context: context,
                                endIndent: 0.0,
                                indent: 0.0,
                              ),
                              defualtLitTale(
                                title: cubit.isDark ? 'Light'.tr : 'Dark'.tr,
                                icon: cubit.isDark
                                    ? Icons.dark_mode
                                    : Icons.light_mode,
                                cubit: cubit,
                                context: context,
                                onClick: () => cubit.changeTheme(!cubit.isDark),
                              ),
                              Component.defaultDivider(
                                context: context,
                                endIndent: 0.0,
                                indent: 0.0,
                              ),
                              defualtLitTale(
                                title: 'Logout'.tr,
                                icon: IconBroken.Logout,
                                cubit: cubit,
                                context: context,
                                onClick: () {
                                  cubit.changeOpenDrawer(0);
                                  PublicFunctions().logOut(context: context);
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget defualtLitTale({
    required AppCubit cubit,
    required IconData icon,
    required String title,
    required BuildContext context,
    required VoidCallback onClick,
  }) =>
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          icon,
          color: cubit.isDark ? Colors.white : Colors.black,
        ),
        title: Text(
          title,
          style:
              Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12.0),
        ),
        onTap: onClick,
      );
}
