/// Configuration pour le service HTTP
class HttpConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final Map<String, String> defaultHeaders;
  final bool enableLogging;

  const HttpConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.defaultHeaders = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    this.enableLogging = true,
  });

  /// Configuration par défaut pour le développement
  static const HttpConfig development = HttpConfig(
    baseUrl: 'https://api.boxtobikers.dev',
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
    sendTimeout: Duration(seconds: 30),
    enableLogging: true,
  );

  /// Configuration par défaut pour la production
  static const HttpConfig production = HttpConfig(
    baseUrl: 'https://api.boxtobikers.com',
    connectTimeout: Duration(seconds: 15),
    receiveTimeout: Duration(seconds: 15),
    sendTimeout: Duration(seconds: 15),
    enableLogging: false,
  );
}

/// Options pour les requêtes HTTP
class HttpRequestOptions {
  final Map<String, String>? headers;
  final Map<String, dynamic>? queryParameters;
  final Duration? timeout;
  final bool? followRedirects;
  final int? maxRedirects;

  const HttpRequestOptions({
    this.headers,
    this.queryParameters,
    this.timeout,
    this.followRedirects,
    this.maxRedirects,
  });

  /// Options par défaut
  static const HttpRequestOptions defaultOptions = HttpRequestOptions();
}
