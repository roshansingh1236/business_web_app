import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bussiness_web_app/config/cache.dart';

class Network {
  // next three lines makes this class a Singleton
  static Network _instance = Network.internal();

  factory Network() => _instance;
  Network.internal();

  final JsonDecoder _decoder = JsonDecoder();

  Future<dynamic> get(String url,
      {Map<String, String> headers, Map<String, String> body}) {
    headers = headers ?? Map<String, String>();
    if (Cache.storage.containsKey('authToken')) {
      headers['Authorization'] = 'JWT ' + Cache.storage.getString('authToken');
    }
    return http.get(url, headers: headers).then((http.Response response) {
      final String data = response.body;
      final int statusCode = response.statusCode;

      if (statusCode == 500) {
        throw Exception('Network connection error');
      }
      if (statusCode != 200) {
        final Map<String, dynamic> error = json.decode(data);
        throw Exception(error['message'].toString());
      }
      return _decoder.convert(data);
    });
  }

  Future<dynamic> post(String url,
      {Map<String, String> headers, body, encoding}) {
    headers = headers ?? Map<String, String>();
    if (Cache.storage.containsKey('authToken')) {
      headers['Authorization'] = 'JWT ' + Cache.storage.getString('authToken');
    }
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      //
      final String data = response.body;
      final int statusCode = response.statusCode;

      if (statusCode == 500) {
        throw Exception("Error while fetching data");
      }
      if (statusCode != 200) {
        final Map<String, dynamic> error = json.decode(data);
        throw Exception(error['message'].toString());
      }
      return _decoder.convert(data);
    });
  }

  Future<dynamic> put(String url,
      {Map<String, String> headers, body, encoding}) {
    headers = headers ?? Map<String, String>();
    if (Cache.storage.containsKey('authToken')) {
      headers['Authorization'] = 'JWT ' + Cache.storage.getString('authToken');
    }
    return http
        .put(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String data = response.body;
      final int statusCode = response.statusCode;

      if (statusCode != 200) {
        final Map<String, dynamic> error = json.decode(data);
        throw Exception(error['message'].toString());
      }
      return _decoder.convert(data);
    });
  }
}
