import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bussiness_web_app/bloc/auth/auth_bloc.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/data/repositories/auth_repository.dart';
import 'package:bussiness_web_app/app.dart';

Future main() async {
  await DotEnv().load('.env');

  Cache.storage = await SharedPreferences.getInstance();

  BlocSupervisor.delegate = SimpleBlocDelegate();
  AuthRepository authRepository = AuthRepository();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    BlocProvider<AuthBloc>(
      create: (context) {
        return AuthBloc(authRepository: authRepository)..add(AppStartedEvent());
      },
      child: App(authRepository: authRepository),
    ),
  );
}
