import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/users/user_profile.dart';
import 'package:social_app/shared/build_user.dart';
import 'package:social_app/shared/component.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        var users = cubit.users.where((element) => element.userId != userId!);
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => BuildUser.buildUser(
                  context: context,
                  user: cubit.users
                      .where((element) => element.userId != userId!)
                      .elementAt(index),
                  screen: UserProfileScreen(
                    user: cubit.users
                        .where((element) => element.userId != userId!)
                        .elementAt(index),
                  ),
                  isList: false,
                ),
                separatorBuilder: (context, index) =>
                    Component.defaultDivider(context: context),
                itemCount: users.length,
              ),
            ),
            Component.defaultFooter(),
          ],
        );
      },
    );
  }
}
