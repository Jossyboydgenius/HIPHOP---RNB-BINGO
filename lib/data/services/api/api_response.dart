import 'package:flutter/foundation.dart';

enum ApiStatus {
  success,
  failure,
}

class ApiResponse {
  dynamic code;
  dynamic data;
  dynamic others;
  bool isSuccessful;
  final bool? isTimeout;
  final String? message;
  final String? errorType;
  final String? errorCode;
  final String? token;
  final String? type;

  ApiResponse({
    this.code,
    this.data,
    this.others,
    required this.isSuccessful,
    this.isTimeout,
    this.message,
    this.token,
    this.errorType,
    this.errorCode,
    this.type,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('errorMessage') && json.containsKey('errorCode')) {
      String errorMessage = json['errorMessage'];
      String errorCode = json['errorCode'];

      if (errorCode == '32' && errorMessage.contains('not found')) {
        errorMessage = 'Email not found';
      }

      return ApiResponse(
        isSuccessful: false,
        message: errorMessage,
        errorCode: errorCode,
        errorType: json['httpStatus'],
      );
    }

    return ApiResponse(
      message: json['message'] ?? json['error'] ?? json['errorMessage'],
      errorType: json['type'],
      errorCode: json['code'],
      isSuccessful: json['success'] ?? false,
      data: json['data'] != null
          ? (json['data'] is bool && json['data'] != false)
              ? json['data']
              : null
          : json['results'],
      token: json['token'],
    );
  }

  factory ApiResponse.timeout() {
    return ApiResponse(
      data: null,
      isSuccessful: false,
      others: 'timeout',
      isTimeout: true,
      message: 'Error occurred. Please try again later',
    );
  }

  factory ApiResponse.unknownError(int code) {
    return ApiResponse(
      isSuccessful: false,
      message: kReleaseMode
          ? 'Error occurred while Communication with our Server, please try again'
          : 'Error occurred while Communication with Server with StatusCode : $code',
    );
  }
}
