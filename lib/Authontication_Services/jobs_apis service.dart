import 'dart:convert';
import 'package:http/http.dart' as http;

class JobService {
  static const String baseUrl = "https://helpr.digital/api/client";

  static Future<Map<String, dynamic>> createJob({
    required int clientId,
    required String category,
    required String title,
    required String description,
    required String imageBase64,
    required int amount,
    required String schedule,
    required String location,
  }) async {
    final url = Uri.parse("$baseUrl/jobs/create");

    print("POST JOB API URL: $url");

    final body = {
      "client_id": clientId,
      "category": category,
      "title": title,
      "description": description,
      "images": imageBase64,
      "amount": amount,
      "schedule": schedule,
      "location": location,
    };

    print("POST JOB BODY: $body");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    print("POST JOB STATUS: ${response.statusCode}");
    print("POST JOB RESPONSE: ${response.body}");

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getClientHome({
    required int clientId,
  }) async {
    final url = Uri.parse("$baseUrl/home");

    print("MY JOBS API URL: $url");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"client_id": clientId}),
    );

    print("MY JOBS STATUS: ${response.statusCode}");
    print("MY JOBS RESPONSE: ${response.body}");

    return jsonDecode(response.body);
  }
}