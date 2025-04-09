import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Signs in with Google and returns the auth token
  Future<String?> signIn() async {
    try {
      // Start the interactive sign-in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in flow
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Return the token that can be sent to your backend
      return googleAuth.idToken;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      return null;
    }
  }

  /// Signs out from Google
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Error signing out from Google: $e');
    }
  }

  /// Checks if a user is currently signed in with Google
  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }
}
