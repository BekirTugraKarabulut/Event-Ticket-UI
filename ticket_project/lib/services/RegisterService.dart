
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {

  final String baseUrl = "http://10.0.2.2:8081";

  Future<Map<String, dynamic>> register({
    required String username,
    required String name,
    required String surname,
    required String password,
    required String phoneNumber
  }) async {

    final url = Uri.parse("$baseUrl/users/register");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "name": name,
        "surname": surname,
        "password": password,
        "phoneNumber": phoneNumber
      }),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {

      return jsonDecode(response.body);
    }

    throw Exception("Kayıt başarısız: ${response.body}");
  }
}
