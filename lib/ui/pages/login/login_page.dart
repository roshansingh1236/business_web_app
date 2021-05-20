import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bussiness_web_app/bloc/auth/auth_bloc.dart';
import 'package:bussiness_web_app/bloc/login/login_bloc.dart';
import 'package:bussiness_web_app/data/repositories/auth_repository.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  final AuthRepository authRepository;

  LoginPage({Key key, @required this.authRepository})
      : assert(authRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocProvider<LoginBloc>(
            create: (context) {
              return LoginBloc(
                authBloc: BlocProvider.of<AuthBloc>(context),
                authRepository: authRepository,
              );
            },
            child: LoginForm(),
          ),
        ));
  }
}
