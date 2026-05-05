import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://fakestoreapi.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // ── Interceptor: Logger ─────────────────────────────────
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );

    // ── Interceptor: Custom (Auth/Error handling) ───────────
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Bisa tambah token di sini jika diperlukan
          options.headers['X-App-Name'] = 'UTD-Store-Salsabila';
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Centralized error handling
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
