/// Modèle générique pour les réponses HTTP
class HttpResponse<T> {
  final T? data;
  final int statusCode;
  final String? message;
  final bool success;

  const HttpResponse({
    this.data,
    required this.statusCode,
    this.message,
    required this.success,
  });

  /// Crée une réponse de succès
  factory HttpResponse.success({
    T? data,
    int statusCode = 200,
    String? message,
  }) {
    return HttpResponse<T>(
      data: data,
      statusCode: statusCode,
      message: message,
      success: true,
    );
  }

  /// Crée une réponse d'erreur
  factory HttpResponse.error({
    int statusCode = 500,
    String? message,
  }) {
    return HttpResponse<T>(
      data: null,
      statusCode: statusCode,
      message: message,
      success: false,
    );
  }

  @override
  String toString() {
    return 'HttpResponse{data: $data, statusCode: $statusCode, message: $message, success: $success}';
  }
}

/// Interface pour les erreurs HTTP personnalisées
abstract class HttpError {
  final String message;
  final int? statusCode;

  const HttpError(this.message, [this.statusCode]);
}

/// Erreur de réseau
class NetworkError extends HttpError {
  const NetworkError(super.message);
}

/// Erreur de timeout
class TimeoutError extends HttpError {
  const TimeoutError(super.message);
}

/// Erreur de validation
class ValidationError extends HttpError {
  const ValidationError(super.message, [super.statusCode]);
}

/// Erreur d'authentification
class AuthenticationError extends HttpError {
  const AuthenticationError(String message) : super(message, 401);
}

/// Erreur d'autorisation
class AuthorizationError extends HttpError {
  const AuthorizationError(String message) : super(message, 403);
}

/// Erreur de ressource non trouvée
class NotFoundError extends HttpError {
  const NotFoundError(String message) : super(message, 404);
}

/// Erreur serveur
class ServerError extends HttpError {
  const ServerError(String message, [int? statusCode]) : super(message, statusCode ?? 500);
}
