import 'package:premium_schooling/models/generic_response.dart';

abstract class AppStates {}

class InitialState extends AppStates {}

class LoadingState extends AppStates {}

class InsertDataSuccessState extends AppStates {
  final GenericResponse response;

  InsertDataSuccessState(this.response);
}

class InsertDataErrorState extends AppStates {
  final String error;
  InsertDataErrorState(this.error);
}
