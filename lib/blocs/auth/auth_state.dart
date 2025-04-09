import 'package:equatable/equatable.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final String? token;
  final String? errorMessage;
  final Map<String, dynamic>? userData;

  const AuthState({
    this.status = AuthStatus.initial,
    this.token,
    this.errorMessage,
    this.userData,
  });

  factory AuthState.initial() {
    return const AuthState(
      status: AuthStatus.initial,
    );
  }

  factory AuthState.loading() {
    return const AuthState(
      status: AuthStatus.loading,
    );
  }

  factory AuthState.authenticated(
      {String? token, Map<String, dynamic>? userData}) {
    return AuthState(
      status: AuthStatus.authenticated,
      token: token,
      userData: userData,
    );
  }

  factory AuthState.unauthenticated() {
    return const AuthState(
      status: AuthStatus.unauthenticated,
    );
  }

  factory AuthState.error(String message) {
    return AuthState(
      status: AuthStatus.error,
      errorMessage: message,
    );
  }

  AuthState copyWith({
    AuthStatus? status,
    String? token,
    String? errorMessage,
    Map<String, dynamic>? userData,
  }) {
    return AuthState(
      status: status ?? this.status,
      token: token ?? this.token,
      errorMessage: errorMessage ?? this.errorMessage,
      userData: userData ?? this.userData,
    );
  }

  @override
  List<Object?> get props => [status, token, errorMessage, userData];
}
