import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookAuthService {
  /// Signs in with Facebook and returns the auth token
  Future<String?> signIn() async {
    try {
      // Start the interactive sign-in process
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        // Get the access token
        final AccessToken accessToken = result.accessToken!;
        return accessToken.token;
      } else {
        debugPrint('Facebook login failed: ${result.status}');
        return null;
      }
    } catch (e) {
      debugPrint('Error signing in with Facebook: $e');
      return null;
    }
  }

  /// Signs out from Facebook
  Future<void> signOut() async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      debugPrint('Error signing out from Facebook: $e');
    }
  }

  /// Checks if a user is currently signed in with Facebook
  Future<bool> isSignedIn() async {
    try {
      final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
      return accessToken != null;
    } catch (e) {
      debugPrint('Error checking Facebook sign-in status: $e');
      return false;
    }
  }
}
