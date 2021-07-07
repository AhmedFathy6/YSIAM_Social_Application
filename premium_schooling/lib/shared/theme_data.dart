import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Constants.dart';

ThemeData lightTheme() => ThemeData(
      primarySwatch: mainColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        titleSpacing: 20.0,
        backgroundColor: Colors.white,
        elevation: 0,
        backwardsCompatibility: false,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Janna',
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: mainColor,
        elevation: 20.0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: mainColor,
      ),
      textTheme: TextTheme(
        headline4: TextStyle(
          color: Colors.black,
        ),
        headline5: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headline6: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 15,
        ),
        bodyText1: TextStyle(
          fontSize: 14.0,
          color: Colors.white,
          height: 1.3,
          fontFamily: 'Janna',
        ),
        bodyText2: TextStyle(
          color: Colors.black,
          fontFamily: 'Janna',
        ),
        subtitle1: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        subtitle2: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w400,
          color: Colors.black,
          fontFamily: 'Janna',
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      fontFamily: 'Janna',
    );
