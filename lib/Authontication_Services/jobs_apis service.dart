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

    print("POST JOB API URL: $url");
    print("POST JOB BODY: $body");

    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      print("POST JOB STATUS: ${response.statusCode}");
      print("POST JOB RESPONSE: ${response.body}");

      if (response.body.trim().isEmpty) {
        return {
          "success": false,
          "message": "Server returned empty response",
        };
      }

      try {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          return decoded;
        }

        return {
          "success": false,
          "message": "Server response format is not valid",
        };
      } catch (e) {
        return {
          "success": false,
          "message": response.body,
          "status_code": response.statusCode,
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Network error: $e",
      };
    }
  }

  static Future<Map<String, dynamic>> getClientHome({
    required int clientId,
  }) async {
    final url = Uri.parse("$baseUrl/home");

    print("MY JOBS API URL: $url");

    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"client_id": clientId}),
      );

      print("MY JOBS STATUS: ${response.statusCode}");
      print("MY JOBS RESPONSE: ${response.body}");

      if (response.body.trim().isEmpty) {
        return {
          "success": false,
          "message": "Server returned empty response",
        };
      }

      try {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          return decoded;
        }

        return {
          "success": false,
          "message": "Server response format is not valid",
        };
      } catch (e) {
        return {
          "success": false,
          "message": "Server returned invalid response",
          "status_code": response.statusCode,
          "raw_response": response.body,
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Network error: $e",
      };
    }
  }
}