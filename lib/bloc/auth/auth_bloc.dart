import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bussiness_web_app/data/models/token_model.dart';
import 'package:bussiness_web_app/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({@required this.authRepository}) : assert(authRepository != null);

  @override
  AuthState get initialState => AuthUninitializedState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStartedEvent) {
      final bool userLoggedIn = authRepository.isLoggedIn();

      if (userLoggedIn) {
        yield AuthAuthenticatedState();
      } else {
        yield AuthUnauthenticatedState();
      }
    }

    if (event is AuthorizeEvent) {
      yield AuthLoadingState();
      authRepository.setLoggedIn(event.token);
      yield AuthAuthenticatedState();
    }

    if (event is UnAuthorizeEvent) {
      yield AuthLoadingState();
      // authRepository.deleteAuth(event.token.token);
      authRepository.logout();
      yield AuthUnauthenticatedState();
    }
  }
}
