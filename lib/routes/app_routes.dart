import 'package:flutter/material.dart';
import 'package:tv_shows/screens/crud_screen.dart';
import 'package:tv_shows/screens/detail_screen.dart';
import 'package:tv_shows/screens/explore_screen.dart';
import 'package:tv_shows/screens/login_screen.dart';
import 'package:tv_shows/screens/profile_screen.dart';
import 'package:tv_shows/screens/register_screen.dart';
import 'package:tv_shows/screens/splash_screen.dart';

/// Manajemen Named Routes & onGenerateRoute aplikasi ToonVerse!
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String explore = '/explore';
  static const String crud = '/crud';
  static const String profile = '/profile';
  static const String detail = '/detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case explore:
        return MaterialPageRoute(builder: (_) => const ExploreScreen());
      case crud:
        return MaterialPageRoute(builder: (_) => const CrudScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case detail:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => DetailScreen(
            show: args['show'] as Map<String, dynamic>? ?? {},
            isFavorite: args['isFavorite'] as bool? ?? false,
            onToggleFavorite: args['onToggleFavorite'] as VoidCallback? ?? () {},
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Halaman tidak ditemukan!')),
          ),
        );
    }
  }
}