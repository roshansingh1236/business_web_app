import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  static final Cache _instance = new Cache.internal();
  static SharedPreferences storage;

  factory Cache() => _instance;
  Cache.internal();
}
