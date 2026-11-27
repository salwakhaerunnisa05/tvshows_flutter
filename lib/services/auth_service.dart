import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service untuk menangani Login, Register, dan Logout ke Laravel API
class AuthService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Menyimpan token dan data user aktif di memori aplikasi
  static String? token;
  static Map<String, dynamic>? currentUser;

  static bool get isLoggedIn => token != null && token!.isNotEmpty;

  /// Login ke POST /api/login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 6));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['token'] != null) {
        token = data['token'].toString();
        currentUser = Map<String, dynamic>.from(data['user'] ?? {'email': email});
        return {'success': true, 'message': data['message'] ?? 'Berhasil masuk!'};
      }
      return {
        'success': false,
        'message': data['message'] ?? 'Email atau password salah!',
      };
    } catch (_) {
      // Mode offline / Laravel belum nyala: tetap izinkan masuk sebagai Tamu
      token = 'offline_demo_token';
      currentUser = {'name': email.split('@').first, 'email': email};
      return {
        'success': true,
        'message': 'Masuk dalam Mode Lokal (Server Laravel belum aktif)',
      };
    }
  }

  /// Register ke POST /api/register
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 6));

      final data = jsonDecode(response.body);
      if ((response.statusCode == 201 || response.statusCode == 200) &&
          data['token'] != null) {
        token = data['token'].toString();
        currentUser = Map<String, dynamic>.from(
          data['user'] ?? {'name': name, 'email': email},
        );
        return {
          'success': true,
          'message': data['message'] ?? 'Akun berhasil dibuat!',
        };
      }
      return {
        'success': false,
        'message': data['message'] ?? 'Gagal mendaftar, periksa data!',
      };
    } catch (_) {
      token = 'offline_demo_token';
      currentUser = {'name': name, 'email': email};
      return {
        'success': true,
        'message': 'Akun lokal siap (Server Laravel belum aktif)',
      };
    }
  }

  /// Logout ke POST /api/logout
  static Future<void> logout() async {
    try {
      if (token != null && token != 'offline_demo_token') {
        await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
    } catch (_) {}
    token = null;
    currentUser = null;
  }
}