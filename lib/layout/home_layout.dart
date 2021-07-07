import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/bottom_navbar.dart';
import 'package:social_app/modules/feeds/new_post_screen.dart';
import 'package:social_app/shared/component.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import 'home_drawer.dart';

class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  DateTime? lastGoBack;
  bool isDragging = false;

  @override
  void initState() {
    if (token == null)
      FirebaseMessaging.instance.getToken().then((value) => token = value);
    AppCubit.get(context).changeBottomNav(0);
    AppCubit.get(context).updateToken();
    if (AppCubit.get(context).currentUser.name == "")
      AppCubit.get(context)
        ..getUserData()
        ..getAllPostsData()
        ..getUsersData();
    super.initState();
    WidgetsBinding.instance!.endOfFrame.then(
      (_) {
        Future.delayed(const Duration(milliseconds: 100),
            () => Get.updateLocale(Locale(lang!)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is SocialNewPostState) {
          Component.navigateTo(
            context,
            NewPostScreen(),
          );
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        final Size size = MediaQuery.of(context).size;
        return WillPopScope(
          onWillPop: () async {
            if (lastGoBack == null) {
              Fluttertoast.showToast(
                msg: 'press back one more time to exit'.tr,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.black26,
                textColor: Colors.white,
                fontSize: 14.0,
              );
              lastGoBack = DateTime.now();
              return false;
            }
            if (DateTime.now().difference(lastGoBack!).inSeconds > 4) {
              Fluttertoast.showToast(
                msg: 'press back one more time to exit'.tr,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.black26,
                textColor: Colors.white,
                fontSize: 14.0,
              );
              return false;
            } else {
              return true;
            }
          },
          child: Scaffold(
            body: Stack(
              alignment: Alignment.centerLeft,
              children: [
                if (cubit.currentUser.name != "") HomeDrawer(),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: cubit.openDrawer),
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInExpo,
                  builder: (_, double val, __) {
                    return (Transform(
                      alignment: AlignmentDirectional.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..setEntry(0, 3, 200 * val)
                        ..rotateY((pi / 6) * val),
                      child: AbsorbPointer(
                        absorbing: cubit.openDrawer == 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              cubit.openDrawer == 1 ? 20 : 0),
                          child: Card(
                            child: Scaffold(
                              appBar: AppBar(
                                leading: IconButton(
                                  icon: Icon(Icons.menu),
                                  onPressed: () {
                                    cubit.changeOpenDrawer(
                                        cubit.openDrawer == 0 ? 1 : 0);
                                  },
                                ),
                                title: Text(
                                  cubit.screens[cubit.currentIndex].values
                                      .elementAt(0)
                                      .tr,
                                ),
                              ),
                              body: Container(
                                height: size.height,
                                width: size.width,
                                child: Stack(
                                  children: [
                                    cubit.screens[cubit.currentIndex].keys
                                        .elementAt(0),
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
                                              painter: BNBCustomPainter(
                                                  context: context),
                                            ),
                                            Center(
                                              heightFactor: 0.6,
                                              child: FloatingActionButton(
                                                backgroundColor: Colors.orange,
                                                child: Icon(
                                                    IconBroken.Paper_Upload),
                                                elevation: 0.1,
                                                onPressed: () =>
                                                    cubit.changeBottomNav(2),
                                              ),
                                            ),
                                            Container(
                                              width: size.width,
                                              height: 80,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      IconBroken.Home,
                                                      color:
                                                          cubit.currentIndex ==
                                                                  0
                                                              ? Colors.orange
                                                              : Colors.grey
                                                                  .shade400,
                                                    ),
                                                    onPressed: () {
                                                      cubit.changeBottomNav(0);
                                                    },
                                                    splashColor: Colors.white,
                                                  ),
                                                  IconButton(
                                                      icon: Icon(
                                                        IconBroken.Chat,
                                                        color:
                                                            cubit.currentIndex ==
                                                                    1
                                                                ? Colors.orange
                                                                : Colors.grey
                                                                    .shade400,
                                                      ),
                                                      onPressed: () {
                                                        cubit
                                                            .changeBottomNav(1);
                                                      }),
                                                  Container(
                                                    width: size.width * 0.20,
                                                  ),
                                                  IconButton(
                                                      icon: Icon(
                                                        IconBroken.User,
                                                        color:
                                                            cubit.currentIndex ==
                                                                    3
                                                                ? Colors.orange
                                                                : Colors.grey
                                                                    .shade400,
                                                      ),
                                                      onPressed: () {
                                                        cubit
                                                            .changeBottomNav(3);
                                                      }),
                                                  IconButton(
                                                      icon: Icon(
                                                        IconBroken.Setting,
                                                        color:
                                                            cubit.currentIndex ==
                                                                    4
                                                                ? Colors.orange
                                                                : Colors.grey
                                                                    .shade400,
                                                      ),
                                                      onPressed: () {
                                                        cubit
                                                            .changeBottomNav(4);
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
                              ),
                            ),
                          ),
                        ),
                      ),
                    ));
                  },
                ),
                WillPopScope(
                  onWillPop: () async {
                    if (cubit.openDrawer == 1) {
                      cubit.changeOpenDrawer(0);
                      return false;
                    } else {
                      return true;
                    }
                  },
                  child: GestureDetector(
                    onHorizontalDragStart: (details) => isDragging = true,
                    onHorizontalDragUpdate: (details) {
                      if (!isDragging) return;
                      const delta = 0;
                      if (details.delta.dx > delta) {
                        cubit.changeOpenDrawer(1);
                      } else {
                        cubit.changeOpenDrawer(0);
                      }
                      isDragging = false;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
