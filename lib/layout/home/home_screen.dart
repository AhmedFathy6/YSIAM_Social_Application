import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home/classic_home_screen.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:get/get.dart';

import 'modern_home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                cubit.changeOpenDrawer(cubit.openDrawer == 0 ? 1 : 0);
              },
            ),
            title: Text(
              cubit.screens[cubit.currentIndex].values.elementAt(0).tr,
            ),
          ),
          body: cubit.appStyle == AppStyle.Modern
              ? HomeModernScreen()
              : HomeClassicScreen(),
        );
      },
    );
  }
}
