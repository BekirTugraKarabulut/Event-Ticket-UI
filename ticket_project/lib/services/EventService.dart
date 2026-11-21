import 'dart:convert';
import 'package:http/http.dart' as http;

class EventService {

  final String baseUrl = "http://10.0.2.2:8082";

  Future<String> uploadImage(String imagePath) async {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/tickets/upload-image"),
    );

    request.files.add(
      await http.MultipartFile.fromPath("file", imagePath),
    );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Fotoğraf yüklenemedi: $responseBody");
    }

    return responseBody.trim();
  }

  Future<void> createEvent(Map<String, dynamic> eventData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/tickets/create-ticket"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(eventData),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Etkinlik oluşturulamadı: ${response.body}");
    }
  }

  Future<List<dynamic>> getAllEvents() async {
    final response = await http.get(
      Uri.parse("$baseUrl/tickets/all"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Etkinlikler getirilemedi!");
    }
  }

  Future<List<dynamic>> getEventsByCategory(int categoryId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/tickets/category/$categoryId"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Kategori etkinlikleri getirilemedi!");
    }
  }

  Future<void> updateEvent(
      int id,
      String day,
      String time,
      ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/tickets/update/$id"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "day": day,
        "time": time,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Etkinlik güncellenemedi: ${response.body}");
    }
  }

  Future<void> deleteEvent(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/tickets/delete/$id"),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Etkinlik silinemedi: ${response.body}");
    }
  }

}
