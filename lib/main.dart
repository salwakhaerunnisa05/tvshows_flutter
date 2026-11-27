import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ToonVerseApp());
}

/// Entry point utama aplikasi ToonVerse! sesuai struktur wajib ujian
class ToonVerseApp extends StatelessWidget {
  const ToonVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToonVerse! Kids',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0EA5E9),
          primary: const Color(0xFF0EA5E9),
          secondary: const Color(0xFFFB923C),
          tertiary: const Color(0xFFEC4899),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F9FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1E293B),
          elevation: 0,
          centerTitle: false,
        ),
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}