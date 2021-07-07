import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/register/register_cubit/Register_states.dart';
import 'package:social_app/modules/register/register_cubit/register_cubit.dart';
import 'package:social_app/shared/component.dart';
import 'package:social_app/shared/functions/funcaions.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final phoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterCreateUserSuccessState) {
            PublicFunctions()
              ..loginSuccess(
                context: context,
                uId: state.user.userId,
              );
          }
          if (state is RegisterCreateUserErrorState) {
            PublicFunctions()
              ..loginError(
                context: context,
                error: state.error,
              );
          }
          if (state is RegisterErrorState) {
            PublicFunctions()
              ..loginError(
                context: context,
                error: state.error,
              );
          }
        },
        builder: (context, state) {
          RegisterCubit cubit = RegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'REGISTER'.tr,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Register now to communicate with your friends'.tr,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Component.defaultTextFormField(
                        controller: nameController,
                        labelText: 'Name'.tr,
                        prefixIcon: Icons.person,
                        type: TextInputType.text,
                        context: context,
                        validator: (value) {
                          if (value!.isEmpty) return 'Must add name'.tr;
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Component.defaultTextFormField(
                        controller: emailController,
                        labelText: 'Email'.tr,
                        prefixIcon: Icons.email_outlined,
                        type: TextInputType.emailAddress,
                        context: context,
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Must add email address'.tr;
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Component.defaultTextFormField(
                        controller: passwordController,
                        labelText: 'Password'.tr,
                        prefixIcon: Icons.vpn_key_outlined,
                        suffixIcon: cubit.suffixIcon,
                        suffixPressed: () => cubit.changePasswordVisibility(),
                        isPassword: cubit.isPassword,
                        context: context,
                        type: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value!.isEmpty) return 'Password is too short'.tr;
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Component.defaultTextFormField(
                        controller: confirmPasswordController,
                        labelText: 'Confirm Password'.tr,
                        prefixIcon: Icons.vpn_key_outlined,
                        suffixIcon: cubit.suffixConfirmIcon,
                        suffixPressed: () =>
                            cubit.changeConfirmPasswordVisibility(),
                        isPassword: cubit.isConfirmPassword,
                        context: context,
                        type: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Must add password'.tr;
                          }
                          if (value != passwordController.text) {
                            return 'Password not match'.tr;
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Component.defaultTextFormField(
                        controller: phoneController,
                        labelText: 'Phone'.tr,
                        prefixIcon: Icons.phone,
                        type: TextInputType.phone,
                        context: context,
                        validator: (value) {
                          if (value!.isEmpty) return 'Must add phone'.tr;
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      state is! RegisterLoadingState
                          ? Component.defaultButton(
                              text: 'REGISTER'.tr,
                              onPressed: () {
                                if (formKey.currentState!.validate())
                                  cubit.userRegister(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name: nameController.text,
                                      phone: phoneController.text);
                              },
                              isUpperCase: true,
                              radius: 20.0,
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
