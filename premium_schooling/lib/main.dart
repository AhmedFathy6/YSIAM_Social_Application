import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:premium_schooling/cubit/app_cubit.dart';
import 'package:premium_schooling/cubit/bloc_observer.dart';
import 'package:premium_schooling/shared/theme_data.dart';
import 'main/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: MaterialApp(
        title: 'Premium Schooling',
        theme: lightTheme(),
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        home: MyHomePage(),
      ),
    );
  }
}
