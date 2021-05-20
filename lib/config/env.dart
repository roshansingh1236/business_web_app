import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String environment = DotEnv().env['APP_ENV'];
  static String name = DotEnv().env['APP_NAME'];
  static String apiBaseUrl = DotEnv().env['API_BASE_URL'];
  static bool isProduction = DotEnv().env['APP_ENV'] == 'production' ? true : false;
}
