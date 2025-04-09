import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiphop_rnb_bingo/services/auth_service.dart';
import 'package:hiphop_rnb_bingo/app/locator.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = locator<AuthService>();

  AuthBloc() : super(AuthState.initial()) {
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<SignInWithApple>(_onSignInWithApple);
    on<SignInWithFacebook>(_onSignInWithFacebook);
    on<SignOut>(_onSignOut);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthState.loading());

      final response = await _authService.authenticateWithGoogle(event.token);

      if (response.isSuccessful) {
        emit(AuthState.authenticated(
          token: response.token,
          userData: response.data,
        ));
      } else {
        emit(AuthState.error(response.message ?? 'Authentication failed'));
      }
    } catch (e) {
      emit(AuthState.error(
          'Error during Google authentication: ${e.toString()}'));
    }
  }

  Future<void> _onSignInWithApple(
    SignInWithApple event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthState.loading());

      final response = await _authService.authenticateWithApple(event.token);

      if (response.isSuccessful) {
        emit(AuthState.authenticated(
          token: response.token,
          userData: response.data,
        ));
      } else {
        emit(AuthState.error(response.message ?? 'Authentication failed'));
      }
    } catch (e) {
      emit(AuthState.error(
          'Error during Apple authentication: ${e.toString()}'));
    }
  }

  Future<void> _onSignInWithFacebook(
    SignInWithFacebook event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthState.loading());

      final response = await _authService.authenticateWithFacebook(event.token);

      if (response.isSuccessful) {
        emit(AuthState.authenticated(
          token: response.token,
          userData: response.data,
        ));
      } else {
        emit(AuthState.error(response.message ?? 'Authentication failed'));
      }
    } catch (e) {
      emit(AuthState.error(
          'Error during Facebook authentication: ${e.toString()}'));
    }
  }

  Future<void> _onSignOut(
    SignOut event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authService.logout();
      emit(AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error('Error during logout: ${e.toString()}'));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final isAuthenticated = await _authService.isAuthenticated();

      if (isAuthenticated) {
        emit(AuthState.authenticated());
      } else {
        emit(AuthState.unauthenticated());
      }
    } catch (e) {
      emit(AuthState.error(
          'Error checking authentication status: ${e.toString()}'));
    }
  }
}
