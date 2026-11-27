import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/tv_shows_data.dart';
import 'auth_service.dart';

/// Service untuk mengambil & mengirim data TV Show dari REST API Laravel
class TvShowService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<Map<String, dynamic>> fetchTvShows() async {
    try {
      final headers = <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      if (AuthService.token != null && AuthService.token != 'offline_demo_token') {
        headers['Authorization'] = 'Bearer ${AuthService.token}';
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/tv-shows'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> rawList =
            decoded is Map<String, dynamic> && decoded['data'] != null
                ? decoded['data'] as List<dynamic>
                : (decoded as List<dynamic>);

        final parsedList = rawList
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();

        return {
          'shows': parsedList,
          'isFromApi': true,
        };
      }
    } catch (_) {
      // Fallback otomatis ke data lokal jika server Laravel belum berjalan
    }

    return {
      'shows': List<Map<String, dynamic>>.from(tvShowsData),
      'isFromApi': false,
    };
  }
}