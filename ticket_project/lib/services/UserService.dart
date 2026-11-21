import 'package:http/http.dart' as http;

class Userservice {

  final String baseUrl = "http://10.0.2.2:8081";

  Future<String> getNameByUsername(String username) async {
    final response = await http.get(
      Uri.parse("$baseUrl/users/name/$username"),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Kullanıcı adı getirilemedi!");
    }
  }

}