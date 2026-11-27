import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser ?? {'name': 'Pengguna ToonVerse', 'email': 'user@toonverse.id'};

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(title: const Text('Profil Pengguna')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0xFF7DD3FC), width: 3.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 42,
                  backgroundColor: Color(0xFFFDE047),
                  child: Icon(Icons.face_rounded, size: 48, color: Color(0xFFEA580C)),
                ),
                const SizedBox(height: 16),
                Text(
                  (user['name'] ?? 'Pengguna').toString(),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  (user['email'] ?? '').toString(),
                  style: const TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () async {
                    await AuthService.logout();
                    if (!context.mounted) return;
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Keluar / Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF43F5E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}