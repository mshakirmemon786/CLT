import 'dart:convert';

import 'package:http/http.dart' as http;


String GET_ALERT = 'https://example.com/api/get_alert';
// Add other API endpoints and constants as needed

// Define functions for making API requests
Future<Map<String, dynamic>> fetchAlert() async {
  final response = await http.get(Uri.parse(GET_ALERT));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load alert');
  }
}
