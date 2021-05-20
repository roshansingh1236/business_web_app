part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final TokenModel token;
  //final UserModel user;

  const LoginSuccessState({@required this.token});

  @override
  List<Object> get props => [token];

  @override
  String toString() => 'LoginSuccess { user: $token }';
}

class LoginFailureState extends LoginState {
  final String error;

  const LoginFailureState({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoginFailure { error: $error }';
}
