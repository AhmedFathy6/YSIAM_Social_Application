import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/firebase/manage_firestore.dart';
import 'package:social_app/shared/network/remote/dio_helper.dart';
import 'Register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitState());
  static RegisterCubit get(context) => BlocProvider.of(context);
  DioHelper dio = DioHelper();
  IconData suffixIcon = Icons.visibility_outlined;
  IconData suffixConfirmIcon = Icons.visibility_outlined;
  bool isPassword = true;
  bool isConfirmPassword = true;
  PickedFile? file;
  Uint8List? imageBytes;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffixIcon =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterPasswordShownState());
  }

  void changeConfirmPasswordVisibility() {
    isConfirmPassword = !isConfirmPassword;
    suffixConfirmIcon = isConfirmPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(RegisterPasswordShownState());
  }

  userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then(
      (value) {
        userCreate(
          user: UserModel(
            name: name,
            phone: phone,
            email: email,
            userId: value.user!.uid,
            image: profileImage,
            coverImage: backgroundImage,
            bio: 'Write your bio ...',
            isEmailVerified: false,
          ),
        );
      },
    ).onError(
      (error, stackTrace) {
        emit(RegisterErrorState(error: error.toString()));
        print(error.toString());
        print(stackTrace);
      },
    );
  }

  userCreate({required UserModel? user}) {
    ManageFireStore.set(
            collection: 'users', document: user!.userId, data: user.toJson())
        .then(
      (value) {
        emit(RegisterCreateUserSuccessState(user: user));
      },
    ).onError(
      (error, stackTrace) {
        emit(RegisterCreateUserErrorState(error: error.toString()));
        print(error.toString());
        print(stackTrace);
      },
    );
  }
}
