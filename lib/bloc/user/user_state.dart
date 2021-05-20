part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserLoadingState extends UserState {}

class UserSuccessState extends UserState {
  final UserModel userProfile;

  UserSuccessState({ @required this.userProfile });

  @override
  List<Object> get props => null;
}

class UserFailureState extends UserState {
  final String message;

  UserFailureState({ @required this.message });

  @override
  List<Object> get props => null;
}
