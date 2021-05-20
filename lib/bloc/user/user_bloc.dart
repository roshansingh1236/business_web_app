import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bussiness_web_app/data/models/user_model.dart';
import 'package:bussiness_web_app/data/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({@required this.userRepository}) : assert(userRepository != null);

  @override
  UserState get initialState => UserLoadingState();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserFetchEvent) {
      yield UserLoadingState();
      try {
        UserModel user = await userRepository.getProfile();
        yield UserSuccessState(userProfile: user);
      } catch (e) {
        yield UserFailureState(message: e.toString());
      }
    }
  }
}
