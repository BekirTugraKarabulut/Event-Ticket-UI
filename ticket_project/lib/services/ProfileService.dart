import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/DtoUserInfo.dart';

class ProfileService {

  static const String baseUrl = "http://10.0.2.2:8081/users";

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");

    if (token == null) {
      throw Exception("Oturum bilgisi bulunamadı.");
    }

    return token;
  }

  Future<DtoUserInfo> getUserInfo() async {

    final token = await getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/info"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return DtoUserInfo.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      "Kullanıcı bilgileri alınamadı: ${response.statusCode}",
    );
  }

  Future<DtoUserInfo> updatePhoneNumber(String phoneNumber) async {

    final token = await getToken();

    final response = await http.put(
      Uri.parse("$baseUrl/update"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "phoneNumber": phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      return DtoUserInfo.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      "Telefon numarası güncellenemedi: ${response.statusCode}",
    );
  }
}
