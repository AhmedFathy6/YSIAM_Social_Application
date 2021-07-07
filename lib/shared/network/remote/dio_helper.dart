import 'package:dio/dio.dart';

import '../../constants.dart';

class DioHelper {
  Dio? dio;
  DioHelper() {
    _init();
  }
  _init() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<Response> getData({
    required String url,
    required Map<String, dynamic> query,
  }) async {
    dio!.options.headers.addAll({
      'Authorization': appToken,
    });
    return await dio!.get(url, queryParameters: query);
  }

  Future<Response> postData(
      {required String url, required data, Map<String, dynamic>? query}) async {
    dio!.options.headers.addAll({
      'Authorization': appToken,
    });

    return await dio!.post(url, data: data, queryParameters: query);
  }

  Future<Response> putData(
      {required String url, required data, Map<String, dynamic>? query}) async {
    dio!.options.headers.addAll({});

    return await dio!.put(url, data: data, queryParameters: query);
  }
}
