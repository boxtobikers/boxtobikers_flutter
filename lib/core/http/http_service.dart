import 'package:boxtobikers/core/http/http_config.dart';
import 'package:boxtobikers/core/http/http_interceptor.dart';
import 'package:boxtobikers/core/http/http_response.dart';
import 'package:dio/dio.dart';

/// Service HTTP centralisé utilisant Dio avec le pattern Singleton
/// Respecte les principes DRY et SOLID
class HttpService {
  static HttpService? _instance;
  late final Dio _dio;
  late final HttpConfig _config;

  // Constructeur privé pour le pattern Singleton
  HttpService._internal();

  /// Instance unique du service HTTP
  static HttpService get instance {
    _instance ??= HttpService._internal();
    return _instance!;
  }

  /// Initialise le service HTTP avec la configuration
  void initialize(HttpConfig config) {
    _config = config;
    _dio = Dio();

    // Configuration de base
    _dio.options.baseUrl = config.baseUrl;
    _dio.options.connectTimeout = config.connectTimeout;
    _dio.options.receiveTimeout = config.receiveTimeout;
    _dio.options.sendTimeout = config.sendTimeout;
    _dio.options.headers = config.defaultHeaders;

    // Ajout des intercepteurs
    _dio.interceptors.addAll([
      LoggingInterceptor(enabled: config.enableLogging),
      AuthInterceptor(),
    ]);
  }

  /// Configure l'authentification
  void configureAuth({
    String? Function()? getToken,
    String? Function()? getRefreshToken,
    Future<String?> Function()? refreshToken,
  }) {
    // Supprime l'ancien intercepteur d'auth s'il existe
    _dio.interceptors.removeWhere((interceptor) => interceptor is AuthInterceptor);
    
    // Ajoute le nouvel intercepteur d'auth
    _dio.interceptors.add(AuthInterceptor(
      getToken: getToken,
      getRefreshToken: getRefreshToken,
      refreshToken: refreshToken,
    ));
  }

  /// Méthode générique pour les requêtes GET
  Future<HttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          receiveTimeout: timeout,
        ),
      );

      return HttpResponse.success(
        data: response.data,
        statusCode: response.statusCode ?? 200,
        message: 'Success',
      );
    } on DioException catch (e) {
      return _handleDioException<T>(e);
    } catch (e) {
      return HttpResponse.error(
        statusCode: 500,
        message: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Méthode générique pour les requêtes POST
  Future<HttpResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          receiveTimeout: timeout,
        ),
      );

      return HttpResponse.success(
        data: response.data,
        statusCode: response.statusCode ?? 201,
        message: 'Created successfully',
      );
    } on DioException catch (e) {
      return _handleDioException<T>(e);
    } catch (e) {
      return HttpResponse.error(
        statusCode: 500,
        message: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Méthode générique pour les requêtes PUT
  Future<HttpResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          receiveTimeout: timeout,
        ),
      );

      return HttpResponse.success(
        data: response.data,
        statusCode: response.statusCode ?? 200,
        message: 'Updated successfully',
      );
    } on DioException catch (e) {
      return _handleDioException<T>(e);
    } catch (e) {
      return HttpResponse.error(
        statusCode: 500,
        message: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Méthode générique pour les requêtes PATCH
  Future<HttpResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          receiveTimeout: timeout,
        ),
      );

      return HttpResponse.success(
        data: response.data,
        statusCode: response.statusCode ?? 200,
        message: 'Updated successfully',
      );
    } on DioException catch (e) {
      return _handleDioException<T>(e);
    } catch (e) {
      return HttpResponse.error(
        statusCode: 500,
        message: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Méthode générique pour les requêtes DELETE
  Future<HttpResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          receiveTimeout: timeout,
        ),
      );

      return HttpResponse.success(
        data: response.data,
        statusCode: response.statusCode ?? 204,
        message: 'Deleted successfully',
      );
    } on DioException catch (e) {
      return _handleDioException<T>(e);
    } catch (e) {
      return HttpResponse.error(
        statusCode: 500,
        message: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Méthode générique pour les requêtes avec upload de fichier
  Future<HttpResponse<T>> uploadFile<T>(
    String path,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? additionalData,
    Map<String, String>? headers,
    Duration? timeout,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?additionalData,
      });

      final response = await _dio.post<T>(
        path,
        data: formData,
        options: Options(
          headers: headers,
          receiveTimeout: timeout,
        ),
        onSendProgress: onSendProgress,
      );

      return HttpResponse.success(
        data: response.data,
        statusCode: response.statusCode ?? 200,
        message: 'File uploaded successfully',
      );
    } on DioException catch (e) {
      return _handleDioException<T>(e);
    } catch (e) {
      return HttpResponse.error(
        statusCode: 500,
        message: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Méthode générique pour les requêtes avec download de fichier
  Future<HttpResponse<String>> downloadFile(
    String path,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Duration? timeout,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await _dio.download(
        path,
        savePath,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          receiveTimeout: timeout,
        ),
        onReceiveProgress: onReceiveProgress,
      );

      return HttpResponse.success(
        data: savePath,
        statusCode: 200,
        message: 'File downloaded successfully',
      );
    } on DioException catch (e) {
      return _handleDioException<String>(e);
    } catch (e) {
      return HttpResponse.error(
        statusCode: 500,
        message: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Gère les exceptions Dio et les convertit en HttpResponse
  HttpResponse<T> _handleDioException<T>(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return HttpResponse.error(
          statusCode: 408,
          message: 'Request timeout',
        );

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 500;
        final message = _extractErrorMessage(e.response?.data) ?? 'Server error';
        return HttpResponse.error(
          statusCode: statusCode,
          message: message,
        );

      case DioExceptionType.cancel:
        return HttpResponse.error(
          statusCode: 499,
          message: 'Request cancelled',
        );

      case DioExceptionType.connectionError:
        return HttpResponse.error(
          statusCode: 503,
          message: 'Connection error',
        );

      case DioExceptionType.badCertificate:
        return HttpResponse.error(
          statusCode: 495,
          message: 'Bad certificate',
        );

      case DioExceptionType.unknown:
      default:
        return HttpResponse.error(
          statusCode: 500,
          message: e.message ?? 'Unknown error',
        );
    }
  }

  /// Extrait le message d'erreur de la réponse
  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    
    if (data is Map<String, dynamic>) {
      return data['message'] ?? data['error'] ?? data['detail'];
    }
    
    if (data is String) {
      return data;
    }
    
    return null;
  }

  /// Ferme le service HTTP
  void dispose() {
    _dio.close();
  }
}
