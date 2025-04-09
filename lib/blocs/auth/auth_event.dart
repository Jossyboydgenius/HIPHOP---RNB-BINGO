import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInWithGoogle extends AuthEvent {
  final String token;

  const SignInWithGoogle(this.token);

  @override
  List<Object?> get props => [token];
}

class SignInWithApple extends AuthEvent {
  final String token;

  const SignInWithApple(this.token);

  @override
  List<Object?> get props => [token];
}

class SignInWithFacebook extends AuthEvent {
  final String token;

  const SignInWithFacebook(this.token);

  @override
  List<Object?> get props => [token];
}

class SignOut extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}
