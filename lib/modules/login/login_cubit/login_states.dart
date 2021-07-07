import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginStates {}

class LoginInitState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  UserCredential user;
  LoginSuccessState({required this.user});
}

class LoginErrorState extends LoginStates {
  final String error;
  LoginErrorState({required this.error});
}

class LoginPasswordShownState extends LoginStates {}
