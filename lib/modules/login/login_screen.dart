import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/shared/component.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/functions/funcaions.dart';
import 'login_cubit/login_cubit.dart';
import 'login_cubit/login_states.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
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
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            PublicFunctions()
              ..loginSuccess(
                context: context,
                uId: state.user.user!.uid,
              );
          }
          if (state is LoginErrorState) {
            PublicFunctions()
              ..loginError(
                context: context,
                error: state.error,
              );
          }
        },
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);

          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('LOGIN'.tr,
                            style: Theme.of(context).textTheme.headline4),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Login now to communicate with your friends'.tr,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 18.0,
                                    color: Colors.grey,
                                  ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Component.defaultTextFormField(
                          controller: emailController,
                          labelText: 'Email'.tr,
                          prefixIcon: Icons.email_outlined,
                          type: TextInputType.emailAddress,
                          context: context,
                          validator: (value) {
                            if (value!.isEmpty) return 'Must add email address';
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
                          context: context,
                          isPassword: cubit.isPassword,
                          type: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value!.isEmpty) return 'Password is too short';
                            return null;
                          },
                          submit: (value) {
                            if (formKey.currentState!.validate())
                              cubit.userLogin(
                                  email: emailController.text,
                                  password: passwordController.text);
                          },
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        state is! LoginLoadingState
                            ? Component.defaultButton(
                                text: 'login'.tr,
                                onPressed: () {
                                  if (formKey.currentState!.validate())
                                    cubit.userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);
                                },
                                isUpperCase: true,
                                radius: 20.0,
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                        Row(
                          children: [
                            Text(
                              'Don\'t have an account?'.tr,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Component.defaultTextButton(
                              onPressed: () {
                                Component.navigateTo(
                                  context,
                                  Directionality(
                                    child: RegisterScreen(),
                                    textDirection: lang == 'en'
                                        ? TextDirection.ltr
                                        : TextDirection.rtl,
                                  ),
                                );
                              },
                              text: 'register'.tr,
                            ),
                          ],
                        )
                      ],
                    ),
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
