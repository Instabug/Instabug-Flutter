/// Constants used throughout the Instabug Flutter SDK
class InstabugConstants {
  InstabugConstants._();

  // Network logging constants
  static const String networkLoggerTag = 'NetworkLogger';
  static const String networkManagerTag = 'NetworkManager';

  // Network body replacement messages
  static const String requestBodyReplacedPrefix = '[REQUEST_BODY_REPLACED]';
  static const String responseBodyReplacedPrefix = '[RESPONSE_BODY_REPLACED]';
  static const String exceedsLimitSuffix = 'exceeds limit';

  /// Generates a request body replacement message
  static String getRequestBodyReplacementMessage(int size) {
    return '$requestBodyReplacedPrefix - Size: $size $exceedsLimitSuffix';
  }

  /// Generates a response body replacement message
  static String getResponseBodyReplacementMessage(int size) {
    return '$responseBodyReplacedPrefix - Size: $size $exceedsLimitSuffix';
  }

  /// Generates a network body size limit exceeded log message
  static String getNetworkBodyLimitExceededMessage({
    required String type,
    required int bodySize,
  }) {
    return 'Network body size limit exceeded for $type - Size: $bodySize';
  }
}
