import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:premium_schooling/models/customer.dart';
import 'package:premium_schooling/models/generic_response.dart';
import 'dart:convert' as convert;
import 'package:premium_schooling/network/remote/dio_helper.dart';
import 'app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  DioHelper dio = DioHelper();

  void insertData(Customer customer) {
    emit(LoadingState());
    dio
        .httpPostData(url: 'ValidClientData', data: customer.toJson())
        .then((value) {
      var jsonResponse = convert.jsonDecode(value.body) as Map<String, dynamic>;
      emit(InsertDataSuccessState(GenericResponse.fromJson(jsonResponse)));
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      emit(InsertDataErrorState(error.toString()));
    });
  }
}
