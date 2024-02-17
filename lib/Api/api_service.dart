import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api-stg.together.buzz/mocks/discovery';

  static Future<List<dynamic>> fetchData({required int page, required int limit}) async {
    final url = Uri.parse('$baseUrl?page=$page&limit=$limit');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        return responseData['data'];
      } else {
        throw Exception('Unexpected data format');
      }
    } else {
      throw Exception('Failed to fetch data. Error ${response.statusCode}');
    }
  }
}
