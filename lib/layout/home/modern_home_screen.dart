import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'bottom_navbar.dart';

class HomeModernScreen extends StatelessWidget {
  const HomeModernScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Container(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              cubit.screens[cubit.currentIndex].keys.elementAt(0),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: size.width,
                  height: 80,
                  child: Stack(
                    // overflow: Overflow.visible,
                    children: [
                      CustomPaint(
                        size: Size(size.width, 80),
                        painter: BNBCustomPainter(context: context),
                      ),
                      Center(
                        heightFactor: 0.6,
                        child: FloatingActionButton(
                          backgroundColor: Colors.orange,
                          child: Icon(IconBroken.Paper_Upload),
                          elevation: 0.1,
                          onPressed: () => cubit.changeBottomNav(2),
                        ),
                      ),
                      Container(
                        width: size.width,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(
                                IconBroken.Home,
                                color: cubit.currentIndex == 0
                                    ? Colors.orange
                                    : Colors.grey.shade400,
                              ),
                              onPressed: () {
                                cubit.changeBottomNav(0);
                              },
                              splashColor: Colors.white,
                            ),
                            IconButton(
                                icon: Icon(
                                  IconBroken.Chat,
                                  color: cubit.currentIndex == 1
                                      ? Colors.orange
                                      : Colors.grey.shade400,
                                ),
                                onPressed: () {
                                  cubit.changeBottomNav(1);
                                }),
                            Container(
                              width: size.width * 0.20,
                            ),
                            IconButton(
                                icon: Icon(
                                  IconBroken.User,
                                  color: cubit.currentIndex == 3
                                      ? Colors.orange
                                      : Colors.grey.shade400,
                                ),
                                onPressed: () {
                                  cubit.changeBottomNav(3);
                                }),
                            IconButton(
                                icon: Icon(
                                  IconBroken.Setting,
                                  color: cubit.currentIndex == 4
                                      ? Colors.orange
                                      : Colors.grey.shade400,
                                ),
                                onPressed: () {
                                  cubit.changeBottomNav(4);
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
