import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:social_app/classes/translation.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/theme_data.dart';

class MainMaterial extends StatelessWidget {
  final bool isLoginBefore = CacheHelper.getData(key: 'isLoginBefore') == null
      ? false
      : CacheHelper.getData(key: 'isLoginBefore');

  Widget getHomePage() {
    return isLoginBefore ? HomeLayout() : LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit()
            ..getUserData()
            ..getAllPostsData()
            ..getUsersData(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return GetMaterialApp(
            home: Directionality(
              child: getHomePage(),
              textDirection:
                  cubit.lang == 'en' ? TextDirection.ltr : TextDirection.rtl,
            ),
            debugShowCheckedModeBanner: false,
            theme: lightTheme(),
            darkTheme: darkTheme(),
            themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
            translations: Translation(),
            locale: Locale('en'),
            fallbackLocale: Locale('en'),
          );
        },
      ),
    );
  }
}
