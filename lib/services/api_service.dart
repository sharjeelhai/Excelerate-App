import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Programs API (existing)
  final String baseUrl =
      'https://mocki.io/v1/1692aba7-af59-4c83-8aea-cf6d85a85e1f';

  Future<List<dynamic>> fetchPrograms() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load programs');
    }
  }

  // Mock feedback submission (for testing)
  Future<bool> submitFeedback({
    required String name,
    required String email,
    required String message,
  }) async {
    // simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return true;
  }
}
