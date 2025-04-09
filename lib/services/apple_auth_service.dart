import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:convert';
import 'dart:math';

class AppleAuthService {
  /// Generates a random string for the nonce
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Signs in with Apple and returns the ID token
  Future<String?> signIn() async {
    try {
      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request.
      final rawNonce = _generateNonce();

      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: base64Encode(utf8.encode(rawNonce)),
      );

      // Get the ID token from the credential
      final idToken = appleCredential.identityToken;

      if (idToken == null) {
        debugPrint('Apple sign in failed: No ID token received');
        return null;
      }

      return idToken;
    } catch (e) {
      debugPrint('Error signing in with Apple: $e');
      return null;
    }
  }
}
