// Dart imports
import 'dart:convert';

// Package imports
import 'package:http/http.dart' as http;

// Models
import '../models/auth_response.dart';

class Auth {
  // ignore: constant_identifier_names
  static const String BASE_URL = "http://localhost:3000";

  static Future<Response> logIn(String email, String password) async {
    final postBody = <String, String>{"email": email, "password": password};

    final response = await http.post(Uri.parse("$BASE_URL/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(postBody));
    final responseJson = jsonDecode(response.body);

    return Response(
        statusCode: response.statusCode,
        error: responseJson["error"],
        result: responseJson["result"]);
  }

  static Future<Response> register(
      String email, String password, String passwordConfirmation) async {
    final postBody = <String, String>{
      "email": email,
      "password": password,
      "passwordConf": passwordConfirmation
    };

    final response = await http.post(Uri.parse("$BASE_URL/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(postBody));
    final responseJson = jsonDecode(response.body);

    return Response(
        statusCode: response.statusCode,
        error: responseJson["error"],
        result: responseJson["result"]);
  }
}
