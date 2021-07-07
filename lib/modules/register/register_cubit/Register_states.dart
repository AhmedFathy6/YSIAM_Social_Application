import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/user_model.dart';

abstract class RegisterStates {}

class RegisterInitState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {
  UserCredential user;
  RegisterSuccessState({required this.user});
}

class RegisterErrorState extends RegisterStates {
  final String error;
  RegisterErrorState({required this.error});
}

class RegisterCreateUserSuccessState extends RegisterStates {
  UserModel user;
  RegisterCreateUserSuccessState({required this.user});
}

class RegisterCreateUserErrorState extends RegisterStates {
  final String error;
  RegisterCreateUserErrorState({required this.error});
}

class RegisterGetImageSuccessState extends RegisterStates {
  Map<Uint8List, PickedFile> image;
  RegisterGetImageSuccessState({required this.image});
}

class RegisterGetImageErrorState extends RegisterStates {
  final String error;
  RegisterGetImageErrorState({required this.error});
}

class RegisterPasswordShownState extends RegisterStates {}
