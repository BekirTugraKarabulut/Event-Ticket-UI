
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartService {

  final String baseUrl = "http://10.0.2.2:8083";

  Future<String> getAccessToken() async {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("accessToken");

    if (token == null || token.isEmpty) {
      throw Exception("Oturum bilgisi bulunamadı!");
    }

    return token;
  }

  Future<void> addToCart(int ticketId, int quantity) async {

    final token = await getAccessToken();

    final response = await http.post(
      Uri.parse("$baseUrl/carts/create-cart"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "ticketId": ticketId,
        "quantity": quantity,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Sepete eklenemedi: ${response.body}");
    }
  }

  Future<List<dynamic>> getCartList(String username) async {

    final token = await getAccessToken();

    final response = await http.get(
      Uri.parse("$baseUrl/carts/list/$username"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Sepet getirilemedi: ${response.body}");
    }
  }

  Future<void> updateCart(int id, int quantity) async {
    final token = await getAccessToken();

    final response = await http.put(
      Uri.parse("$baseUrl/carts/update-cart/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(quantity),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Bilet adedi güncellenemedi: ${response.body}");
    }
  }

  Future<void> deleteCart(int sepetId) async {
    final token = await getAccessToken();

    final response = await http.delete(
      Uri.parse("$baseUrl/carts/delete-cart/$sepetId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Sepet ürünü silinemedi: ${response.body}");
    }
  }

}
