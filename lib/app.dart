import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bussiness_web_app/bloc/auth/auth_bloc.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/data/repositories/auth_repository.dart';
import 'package:bussiness_web_app/route.dart';
import 'package:bussiness_web_app/ui/pages/business/add_business.dart';
import 'package:bussiness_web_app/ui/pages/home/agent_home.dart';
import 'package:bussiness_web_app/ui/pages/home/delivery_home.dart';
import 'package:bussiness_web_app/ui/pages/home/home_page.dart';
import 'package:bussiness_web_app/ui/pages/login/login_page.dart';
import 'package:bussiness_web_app/ui/pages/splash_page.dart';
import 'package:bussiness_web_app/ui/widgets/loader_widget.dart';
import 'package:splashscreen/splashscreen.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

class App extends StatelessWidget {
  final AuthRepository authRepository;
  final role = Cache.storage.getString('vendorRole');

  App({Key key, @required this.authRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.grey[50],
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticatedState) {
            return Cache.storage.getInt('isProfileCompleted') == 1
                ? SplashScreen(
                    title: new Text(
                      'Simplify The Complex',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.black),
                    ),
                    seconds: 4,
                    navigateAfterSeconds:
                        Cache.storage.getString('vendorRole') == "teamMember"
                            ? DeliveryHomePage()
                            : Cache.storage.getString('vendorRole') ==
                                    "Real Estate Agent"
                                ? AgentHomePage()
                                : HomePage(),
                    image: new Image.asset(
                      'assets/images/Briclay Technologies App Icon-01.png',
                      width: 600,
                    ),
                    backgroundColor: Colors.white,
                    styleTextUnderTheLoader: new TextStyle(),
                    photoSize: 150.0,
                    onClick: () => print("Flutter"),
                    loaderColor: Colors.black,
                  )
                : BusinessPage();
          }
          if (state is AuthUnauthenticatedState) {
            return LoginPage(authRepository: authRepository);
          }
          if (state is AuthLoadingState) {
            return LoaderWidget();
          }
          return SplashPage();
        },
      ),
      initialRoute: '/',
      routes: routes,
    );
  }
}
