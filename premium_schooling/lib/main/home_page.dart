import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:premium_schooling/cubit/app_cubit.dart';
import 'package:premium_schooling/cubit/app_states.dart';
import 'package:premium_schooling/models/customer.dart';
import 'package:premium_schooling/models/device_info.dart';
import 'package:premium_schooling/ui_components/info_widget.dart';
import '../shared/component.dart';

class MyHomePage extends StatelessWidget {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final premiumCardController = TextEditingController();
  final workController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return InfoWidget(
      builder: (context, deviceInfo) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/SchoolingFinal.jpg'),
              fit: BoxFit.fill),
        ),
        child: Scaffold(
          backgroundColor:
              HexColor('#466955').withOpacity(0.2), //Colors.transparent,
          body: RefreshIndicator(
            onRefresh: clearControllersData,
            edgeOffset: 10.0,
            color: Colors.blue,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildImages(deviceInfo, 'assets/images/delwaty.png'),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 10.0),
                        child: Container(
                          padding: EdgeInsetsDirectional.only(top: 5.0),
                          width: deviceInfo.screenWidth * .30,
                          child: Image.asset('assets/images/logo.png'),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  buildImages(deviceInfo, 'assets/images/mazaya.png'),
                  SizedBox(
                    height: 30,
                  ),
                  buildImages(deviceInfo, 'assets/images/gadwal.png'),
                  SizedBox(
                    height: 30.0,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: [
                        SizedBox(
                          width: deviceInfo.screenWidth * .10,
                        ),
                        Container(
                          width: deviceInfo.screenWidth * .50,
                          child: buildItems(context, deviceInfo),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> clearControllersData() async {
    Completer<Null> completer = new Completer<Null>();
    completer.complete();
    await new Future.delayed(new Duration(seconds: 1));

    nameController.text = '';
    mobileController.text = '';
    premiumCardController.text = '';
    workController.text = '';

    return completer.future;
  }

  Widget buildItems(BuildContext context, DeviceInfo size) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is InsertDataSuccessState) {
          if (state.response.status == 1) {
            Component.buildAlert(
              context: context,
              title: 'خطأ',
              body: state.response.responseTextArabic!,
              dialogType: DialogType.ERROR,
              hideAfter: Duration(seconds: 3),
            ).show();
          } else {
            nameController.text = '';
            mobileController.text = '';
            premiumCardController.text = '';
            workController.text = '';
            Component.buildAlert(
              context: context,
              title: 'عملية ناجحة',
              body: state.response.responseTextArabic!,
              dialogType: DialogType.SUCCES,
              hideAfter: Duration(seconds: 3),
            ).show();
          }
        }
        if (state is InsertDataErrorState) {
          Component.buildAlert(
            context: context,
            title: 'خطأ',
            body: 'خطأ حاول مرة آخرى',
            dialogType: DialogType.ERROR,
            hideAfter: Duration(seconds: 3),
          ).show();
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Form(
          key: formKey,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ':الأســـــم',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Component.defaultTextFormField(
                    controller: nameController,
                    labelText: '',
                    type: TextInputType.text,
                    validator: (value) {
                      if (value!.trim().isEmpty)
                        return 'يجب أضافة الأســـــم';
                      else
                        return null;
                    },
                    borderRadius: 0,
                    context: context,
                    hideBorder: true,
                    maxLength: 150,
                    hideCounter: true,
                  ),
                ],
              ),
              SizedBox(
                height: size.screenHeight * .02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ':رقــــم المحمـــــول',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Component.defaultTextFormField(
                    controller: mobileController,
                    labelText: '',
                    type: TextInputType.phone,
                    validator: (value) {
                      if (value!.trim().isEmpty)
                        return 'يجب أضافة رقــــم المحمـــــول';
                      else
                        return null;
                    },
                    borderRadius: 0,
                    context: context,
                    hideBorder: true,
                    maxLength: 11,
                  ),
                ],
              ),
              SizedBox(
                height: size.screenHeight * .02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ':رقم بطاقة بريميـــوم كـــارد',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Component.defaultTextFormField(
                    controller: premiumCardController,
                    labelText: '',
                    type: TextInputType.number,
                    validator: (value) {
                      if (value!.trim().isEmpty)
                        return 'يجب أضافة رقم الكـــارد';
                      else
                        return null;
                    },
                    borderRadius: 0,
                    context: context,
                    hideBorder: true,
                    maxLength: 16,
                  ),
                ],
              ),
              SizedBox(
                height: size.screenHeight * .02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ':جهـــــة العمـــــــل',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Component.defaultTextFormField(
                    controller: workController,
                    labelText: '',
                    type: TextInputType.text,
                    validator: (value) {
                      if (value!.trim().isEmpty)
                        return 'يجب أضافة جهـــــة العمـــــــل';
                      else
                        return null;
                    },
                    borderRadius: 0,
                    context: context,
                    hideBorder: true,
                    maxLength: 150,
                    hideCounter: true,
                  ),
                ],
              ),
              SizedBox(
                height: size.screenHeight * .02,
              ),
              state is LoadingState
                  ? CircularProgressIndicator()
                  : Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: MaterialButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            cubit.insertData(
                              Customer(
                                cardNumber: premiumCardController.text,
                                clientName: nameController.text,
                                employer: workController.text,
                                phoneNumber: mobileController.text,
                              ),
                            );
                          }
                        },
                        textColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'ســـــجـــــل الآن',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        color: Colors.red,
                      ),
                    ),
              SizedBox(
                height: size.screenHeight * .05,
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget buildImages(DeviceInfo size, String image) => Row(
      children: [
        SizedBox(
          width: size.screenWidth * .10,
        ),
        Container(
          width: size.screenWidth * .50,
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Image.asset(image),
          ),
        ),
      ],
    );
