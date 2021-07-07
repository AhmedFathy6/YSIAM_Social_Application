import 'package:dio/dio.dart';
import 'package:premium_schooling/shared/Constants.dart';
import 'package:http/http.dart' as http;

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
    String lang = 'en',
    String token = '',
  }) async {
    dio!.options.headers.addAll({
      'lang': lang,
      'Authorization': token,
    });
    return await dio!.get(url, queryParameters: query);
  }

  Future<Response> postData(
      {required String url,
      required data,
      String lang = 'en',
      String token = '',
      Map<String, dynamic>? query}) async {
    dio!.options.headers.addAll({
      'lang': lang,
      'Authorization': token,
    });

    return await dio!.post(url, data: data, queryParameters: query);
  }

  Future<http.Response> httpPostData(
      {required String url, required data, Map<String, dynamic>? query}) async {
    Uri uri = Uri.parse(baseUrl + 'ValidClientData');
    return await http.post(uri, body: data);
  }

  Future<Response> putData(
      {required String url,
      required data,
      String lang = 'en',
      String token = '',
      Map<String, dynamic>? query}) async {
    dio!.options.headers.addAll({
      'lang': lang,
      'Authorization': token,
    });

    return await dio!.put(url, data: data, queryParameters: query);
  }
}
