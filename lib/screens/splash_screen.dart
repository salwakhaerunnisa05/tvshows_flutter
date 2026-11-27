import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0EA5E9),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFFFDE047),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: const Icon(
                Icons.sentiment_very_satisfied_rounded,
                size: 56,
                color: Color(0xFFEA580C),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'ToonVerse! Kids',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '✨ Dunia Kartun & Edukasi Anak',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFEF08A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}