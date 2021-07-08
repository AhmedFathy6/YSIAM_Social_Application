import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/notification_model.dart';
import 'package:social_app/modules/chats/chat_screen.dart';
import 'package:social_app/shared/build_user.dart';
import 'package:social_app/shared/component.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class ChatsScreen extends StatelessWidget {
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
                  user: users.elementAt(index),
                  screen: ChatScreen(
                    user: users.elementAt(index),
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
