/// Server-side error (non-2xx response)
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

/// Local storage / cache error
class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

/// No internet connection
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

/// Unauthorized (401) – token expired or invalid
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'Unauthorized']);
}
