import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/post/post_layout.dart';
import 'package:social_app/shared/component.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class FeedsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return RefreshIndicator(
          onRefresh: () async {
            Completer<Null> completer = new Completer<Null>();
            completer.complete();
            await new Future.delayed(new Duration(seconds: 1));
            cubit.getAllPostsData();
          },
          edgeOffset: 10.0,
          color: Colors.blue,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 10.0,
                    margin: EdgeInsets.all(
                      8.0,
                    ),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Image(
                          image: NetworkImage(backgroundImage),
                          height: 200.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'communicate with friends'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => BuildPost.buildPostItem(
                      context: context,
                      cubit: cubit,
                      post: cubit.allPosts[index],
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cubit.allPosts.length,
                  ),
                ),
                Component.defaultFooter(),
              ],
            ),
          ),
        );
      },
    );
  }
}
