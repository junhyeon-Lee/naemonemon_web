import 'package:dio/dio.dart';
import 'api_constants.dart';
import 'dio_interceptor.dart';

class HttpService {
  static final HttpService _instance = HttpService._internal();
  static Dio _dio = Dio();

  factory HttpService() {
    return _instance;
  }

  HttpService._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: APIConstants.baseUrl,
    );
    _dio = Dio(options);
    _dio.interceptors.add(DioCustomInterceptor());
  }

  Future<void> init({
    String baseUrl = APIConstants.baseUrl,
    int connectTimeout = 8000,
    int receiveTimeout = 8000,
    Map<String, String>? headers,
    List<Interceptor>? interceptors,
  }) async {
    _dio.options = _dio.options.copyWith(baseUrl: baseUrl, connectTimeout: Duration(milliseconds: connectTimeout), receiveTimeout:  Duration(milliseconds: receiveTimeout), headers: headers);

    if (interceptors != null && interceptors.isNotEmpty) {
      _dio.interceptors.addAll(interceptors);
    }
  }

  void setAccessToken(String accessToken) {
    init(headers: {
      'Content-Type': 'text/plain'
    });
  }
  void deleteAccessToken() {
    init(headers: {});
  }

  Dio to() {
    return _dio;
  }
}
