/// **Custom API Exceptions** for structured error handling
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => "ApiException: $message";
}

/// No Internet Exception
class NoInternetException extends ApiException {
  NoInternetException() : super("No Internet Connection");
}

/// Request Timeout Exception
class RequestTimeoutHttpException extends HttpErrorException {
  RequestTimeoutHttpException(String message) : super(408, message);
}



/// Invalid Format Exception
class InvalidFormatException extends ApiException {
  InvalidFormatException() : super("Invalid Response Format");
}

/// HTTP Exceptions (Handles Different Status Codes)
class HttpErrorException extends ApiException {
  final int statusCode;

  HttpErrorException(this.statusCode, String message)
      : super("HTTP Error ($statusCode): $message");

  /// **Factory Constructor for Dynamic Exception Mapping**
  factory HttpErrorException.fromStatusCode(int statusCode, String message) {
    switch (statusCode) {
      case 100:
        return InformationalResponseException(statusCode, message);
      case 101:
        return SwitchingProtocolsException(message);
      case 200:
      case 201:
      case 202:
      case 204:
        return SuccessResponseException(statusCode, message);
      case 301:
      case 302:
      case 304:
        return RedirectionException(statusCode, message);
      case 400:
        return BadRequestException(message);
      case 401:
        return UnauthorizedException(message);
      case 402:
        return PaymentRequiredException(message);
      case 403:
        return ForbiddenException(message);
      case 404:
        return NotFoundException(message);
      case 405:
        return MethodNotAllowedException(message);
      case 406:
        return NotAcceptableException(message);
      case 408:
        return RequestTimeoutHttpException(message);
      case 409:
        return ConflictException(message);
      case 410:
        return GoneException(message);
      case 413:
        return PayloadTooLargeException(message);
      case 415:
        return UnsupportedMediaTypeException(message);
      case 429:
        return TooManyRequestsException(message);
      case 500:
        return InternalServerErrorException(message);
      case 501:
        return NotImplementedException(message);
      case 502:
        return BadGatewayException(message);
      case 503:
        return ServiceUnavailableException(message);
      case 504:
        return GatewayTimeoutException(message);
      default:
        return HttpErrorException(statusCode, "Unexpected error: $message");
    }
  }
}


class BadRequestException extends HttpErrorException {
  BadRequestException(String message) : super(400, message);
}

class UnauthorizedException extends HttpErrorException {
  UnauthorizedException(String message) : super(401, message);
}

class ForbiddenException extends HttpErrorException {
  ForbiddenException(String message) : super(403, message);
}

class NotFoundException extends HttpErrorException {
  NotFoundException(String message) : super(404, message);
}

class InternalServerErrorException extends HttpErrorException {
  InternalServerErrorException(String message) : super(500, message);
}

// ✅ Informational Responses (100 - 199)
class InformationalResponseException extends HttpErrorException {
  InformationalResponseException(int statusCode, String message) : super(statusCode, message);
}

class SwitchingProtocolsException extends HttpErrorException {
  SwitchingProtocolsException(String message) : super(101, message);
}

// ✅ Success Responses (200 - 299)
class SuccessResponseException extends HttpErrorException {
  SuccessResponseException(int statusCode, String message) : super(statusCode, message);
}

// ✅ Redirection Responses (300 - 399)
class RedirectionException extends HttpErrorException {
  RedirectionException(int statusCode, String message) : super(statusCode, message);
}

// ✅ Client Errors (400 - 499)
class PaymentRequiredException extends HttpErrorException {
  PaymentRequiredException(String message) : super(402, message);
}

class MethodNotAllowedException extends HttpErrorException {
  MethodNotAllowedException(String message) : super(405, message);
}

class NotAcceptableException extends HttpErrorException {
  NotAcceptableException(String message) : super(406, message);
}

class ConflictException extends HttpErrorException {
  ConflictException(String message) : super(409, message);
}

class GoneException extends HttpErrorException {
  GoneException(String message) : super(410, message);
}

class PayloadTooLargeException extends HttpErrorException {
  PayloadTooLargeException(String message) : super(413, message);
}

class UnsupportedMediaTypeException extends HttpErrorException {
  UnsupportedMediaTypeException(String message) : super(415, message);
}

class TooManyRequestsException extends HttpErrorException {
  TooManyRequestsException(String message) : super(429, message);
}

// ✅ Server Errors (500 - 599)
class NotImplementedException extends HttpErrorException {
  NotImplementedException(String message) : super(501, message);
}

class BadGatewayException extends HttpErrorException {
  BadGatewayException(String message) : super(502, message);
}

class ServiceUnavailableException extends HttpErrorException {
  ServiceUnavailableException(String message) : super(503, message);
}

class GatewayTimeoutException extends HttpErrorException {
  GatewayTimeoutException(String message) : super(504, message);
}
