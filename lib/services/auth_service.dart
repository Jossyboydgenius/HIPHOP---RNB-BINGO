import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/services/api/api.dart';
import '../data/services/api/api_response.dart';
import '../data/services/local_storage_service.dart';
import '../app/locator.dart';

class AuthService {
  final Api _api = locator<Api>();
  final LocalStorageService _storageService = locator<LocalStorageService>();

  Future<ApiResponse> authenticateWithGoogle(String token) async {
    try {
      final body = {'token': token};

      final response = await _api.postData(
        '/api/auth/google',
        body,
        hasHeader: false,
      );

      if (response.isSuccessful && response.data != null) {
        // Save the token to secure storage
        if (response.token != null) {
          await _storageService.setStorageValue(
              LocalStorageKeys.accessToken, response.token!);

          // Update API service token
          _api.updateToken(response.token);
        }
      }

      return response;
    } catch (e) {
      debugPrint('Error authenticating with Google: $e');
      return ApiResponse(
        isSuccessful: false,
        message: 'Authentication failed: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse> authenticateWithFacebook(String token) async {
    try {
      final body = {'token': token};

      final response = await _api.postData(
        '/api/auth/facebook',
        body,
        hasHeader: false,
      );

      if (response.isSuccessful && response.data != null) {
        // Save the token to secure storage
        if (response.token != null) {
          await _storageService.setStorageValue(
              LocalStorageKeys.accessToken, response.token!);

          // Update API service token
          _api.updateToken(response.token);
        }
      }

      return response;
    } catch (e) {
      debugPrint('Error authenticating with Facebook: $e');
      return ApiResponse(
        isSuccessful: false,
        message: 'Authentication failed: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse> authenticateWithApple(String token) async {
    try {
      final body = {'token': token};

      final response = await _api.postData(
        '/api/auth/apple',
        body,
        hasHeader: false,
      );

      if (response.isSuccessful && response.data != null) {
        // Save the token to secure storage
        if (response.token != null) {
          await _storageService.setStorageValue(
              LocalStorageKeys.accessToken, response.token!);

          // Update API service token
          _api.updateToken(response.token);
        }
      }

      return response;
    } catch (e) {
      debugPrint('Error authenticating with Apple: $e');
      return ApiResponse(
        isSuccessful: false,
        message: 'Authentication failed: ${e.toString()}',
      );
    }
  }

  Future<bool> isAuthenticated() async {
    final token =
        await _storageService.getStorageValue(LocalStorageKeys.accessToken);
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await _storageService.removeStorageValue(LocalStorageKeys.accessToken);
    _api.updateToken(null);
  }
}
