
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Loginservice {

  final String baseUrl = "http://10.0.2.2:8081";

  Future<bool> login({
    required String username,
    required String password,
  }) async {

    final url = Uri.parse("$baseUrl/users/auth");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {

      final responseData = jsonDecode(response.body);

      final accessToken = responseData["accessToken"];
      final refreshToken = responseData["refreshToken"];

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("accessToken", accessToken);
      await prefs.setString("refreshToken", refreshToken);

      return true;
    }

    return false;
  }

  Future<String?> getAccessToken() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("accessToken");
  }

  Future<String?> getRefreshToken() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("refreshToken");
  }

  Future<void> logout() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("accessToken");
    await prefs.remove("refreshToken");
  }
}
