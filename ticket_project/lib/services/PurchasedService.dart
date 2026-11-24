
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PurchasedService {

  final String baseUrl = "http://10.0.2.2:8084";

  Future<List<dynamic>> getMyPurchases() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");

    final response = await http.get(
      Uri.parse("$baseUrl/purchased/my-purchases"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "Biletler alınamadı: ${response.statusCode} ${response.body}",
      );
    }
  }

  Future<String> getAccessCodeByPurchasedId(int purchaseId) async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");

    if (token == null) {
      throw Exception("Oturum bilgisi bulunamadı.");
    }

    final response = await http.get(
      Uri.parse(
        "$baseUrl/purchased/access-code/$purchaseId",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return response.body.replaceAll('"', '');
    }

    throw Exception(
      "Giriş kodu alınamadı: ${response.statusCode}",
    );
  }

}
