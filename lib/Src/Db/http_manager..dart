import 'package:dio/dio.dart';

abstract class HttpMethod {
  static const String get = 'GET';
  static const String post = 'POST';
  static const String put = 'PUT';
  static const String delete = 'DELETE';
  static const String patch = 'PATCH';
}

class HttpManager {
  HttpManager({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<Map<String, dynamic>> restRequest({
    required String url,
    required String method,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
  }) async {
    final defaultHeaders = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Parse-Application-Id': '5TIRwNPBnxU0J0E8zVT4weGxs0HjSit3QAGVX6p1',
      'X-Parse-REST-API-Key': '2BwF96uB9nqBCjvZoe5DRKfPys0atqPWaRZeKHcN',
    };

    if (headers != null) {
      headers.forEach((k, v) => defaultHeaders[k] = v.toString());
    }

    try {
      final response = await _dio.request(
        url,
        options: Options(headers: defaultHeaders, method: method),
        data: body,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) return data;
      if (data is Map) return data.cast<String, dynamic>();

      return <String, dynamic>{'result': data};
    } on DioException catch (error) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) return data;
      if (data is Map) return data.cast<String, dynamic>();
      return <String, dynamic>{
        'error': true,
        'message': error.message ?? 'dio_error',
      };
    } catch (error) {
      return <String, dynamic>{'error': true, 'message': error.toString()};
    }
  }
}
