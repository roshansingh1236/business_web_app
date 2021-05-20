part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStartedEvent extends AuthEvent {}

class AuthorizeEvent extends AuthEvent {
  final TokenModel token;

  const AuthorizeEvent({@required this.token});

  @override
  List<Object> get props => [token];

  @override
  String toString() => 'LoggedIn { token: $token }';
}

class UnAuthorizeEvent extends AuthEvent {
  final TokenModel token;

  const UnAuthorizeEvent({this.token});

  @override
  List<Object> get props => [token];

  @override
  String toString() => 'LoggedOut { token: $token[\'token\'] }';
}
