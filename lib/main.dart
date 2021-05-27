import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bussiness_web_app/bloc/auth/auth_bloc.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/data/repositories/auth_repository.dart';
import 'package:bussiness_web_app/app.dart';
import 'package:url_strategy/url_strategy.dart';

Future main() async {
  await DotEnv().load('.env');

  Cache.storage = await SharedPreferences.getInstance();

  BlocSupervisor.delegate = SimpleBlocDelegate();
  AuthRepository authRepository = AuthRepository();
  WidgetsFlutterBinding.ensureInitialized();
  // Here we set the URL strategy for our web app.
  // It is safe to call this function when running on mobile or desktop as well.
  setPathUrlStrategy();
  runApp(
    BlocProvider<AuthBloc>(
      create: (context) {
        return AuthBloc(authRepository: authRepository)..add(AppStartedEvent());
      },
      child: App(authRepository: authRepository),
    ),
  );
}
