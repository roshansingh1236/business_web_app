part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthUninitializedState extends AuthState {}

class AuthAuthenticatedState extends AuthState {}

class AuthUnauthenticatedState extends AuthState {}

class AuthLoadingState extends AuthState {}
