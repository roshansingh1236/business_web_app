import 'dart:async';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:bussiness_web_app/bloc/auth/auth_bloc.dart';
import 'package:bussiness_web_app/data/models/token_model.dart';
import 'package:bussiness_web_app/data/repositories/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc authBloc;
  final AuthRepository authRepository;

  LoginBloc({@required this.authBloc, @required this.authRepository})
      : assert(authRepository != null),
        assert(authBloc != null);

  @override
  LoginState get initialState => LoginInitialState();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginSubmitEvent) {
      yield LoginLoadingState();

      try {
        final userToken = await authRepository.login(
            phoneNumber: event.phoneNumber,
            otp: event.otp,
            isforeign: event.isforeign,
            deviceType: event.deviceType,
            deviceId: event.deviceId,
            token: event.token,
            email: event.email);

        authBloc.add(AuthorizeEvent(token: userToken['token']));
        yield LoginSuccessState(token: userToken['token']);
      } catch (e) {
        yield LoginFailureState(error: e.toString());
      }
    }
  }
}
