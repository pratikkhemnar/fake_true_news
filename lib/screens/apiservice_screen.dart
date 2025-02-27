import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.0.108:8080"; // FastAPI URL

  static Future<Map<String, dynamic>> predictNews(String newsText) async {
    final response = await http.post(
      Uri.parse("$baseUrl/predict/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"text": newsText}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to get prediction");
    }
  }
}
