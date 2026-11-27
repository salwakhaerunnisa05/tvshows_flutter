/// Konfigurasi terpusat Base URL Laravel API & Public API
class ApiConstant {
  // Sesuaikan dengan environment:
  // - Chrome / Web / iOS Simulator : http://127.0.0.1:8000/api
  // - Android Emulator             : http://10.0.2.2:8000/api
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Endpoints Auth
  static const String loginEndpoint = '$baseUrl/login';
  static const String registerEndpoint = '$baseUrl/register';
  static const String logoutEndpoint = '$baseUrl/logout';

  // Endpoints CRUD TV Shows
  static const String tvShowsEndpoint = '$baseUrl/tv-shows';
}