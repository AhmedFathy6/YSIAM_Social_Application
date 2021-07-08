import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:get/get.dart';

class HomeClassicScreen extends StatelessWidget {
  const HomeClassicScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          body: cubit.screens[cubit.currentIndex].keys.elementAt(0),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) => cubit.changeBottomNav(index),
            items: [
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Home),
                label: 'News Feed'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Chat),
                label: 'Chats'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Paper_Upload),
                label: 'Post'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.User),
                label: 'Friends'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Setting),
                label: 'Profile'.tr,
              ),
            ],
          ),
        );
      },
    );
  }
}
