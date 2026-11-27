import 'dart:async';
import 'package:flutter/material.dart';

/// Halaman detail kartun & simulasi pemutar episode (100% mandiri di lib/screens/)
class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> show;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const DetailScreen({
    super.key,
    required this.show,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool _isFav;
  int _activeEpisodeIndex = 0;
  bool _isPlaying = false;
  double _progress = 0.15;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _isFav = widget.isFavorite;
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() {
          _progress = (_progress + 0.03).clamp(0.0, 1.0);
          if (_progress >= 1.0) {
            _progress = 0.0;
            _isPlaying = false;
            timer.cancel();
          }
        });
      });
    } else {
      _timer?.cancel();
    }
  }

  void _selectEpisode(int index) {
    setState(() {
      _activeEpisodeIndex = index;
      _progress = 0.05;
      _isPlaying = true;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _progress = (_progress + 0.03).clamp(0.0, 1.0));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final show = widget.show;
    final rawEpisodes = (show['episodes'] as List<dynamic>?) ?? ['Episode 1'];
    final List<String> episodes = rawEpisodes.map((ep) {
      if (ep is Map) return (ep['title'] ?? ep['name'] ?? 'Episode').toString();
      return ep.toString();
    }).toList();

    final theme = _resolveCategoryTheme(show['category']?.toString());
    final List<Color> gradientColors = theme['gradients'] as List<Color>;
    final IconData iconData = theme['icon'] as IconData;
    final String imageUrl =
        (show['image_url'] ?? show['imageUrl'] ?? '').toString();
    final currentEpTitle =
        episodes.isNotEmpty ? episodes[_activeEpisodeIndex] : 'Episode 1';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0284C7)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          (show['title'] ?? '').toString(),
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() => _isFav = !_isFav);
              widget.onToggleFavorite();
            },
            icon: Icon(
              _isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: const Color(0xFFEC4899),
              size: 28,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 230,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFFDE047), width: 4),
                gradient: LinearGradient(colors: gradientColors),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl.isNotEmpty)
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Center(child: Icon(iconData, size: 70, color: Colors.white)),
                    )
                  else
                    Center(child: Icon(iconData, size: 70, color: Colors.white)),
                  Container(color: Colors.black.withOpacity(0.35)),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: _togglePlay,
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDE047),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: Icon(
                              _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: const Color(0xFFEA580C),
                              size: 42,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _isPlaying
                                ? '🍿 Memutar: Ep ${_activeEpisodeIndex + 1} - $currentEpTitle'
                                : '🎬 Tekan tombol kuning untuk menonton!',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isPlaying)
                    Positioned(
                      left: 14,
                      right: 14,
                      bottom: 12,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _progress,
                          minHeight: 8,
                          backgroundColor: Colors.white30,
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFDE047)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFFBAE6FD), width: 3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTag('📺 ${show['channel'] ?? 'TV Kids'}', const Color(0xFFE0F2FE), const Color(0xFF0369A1)),
                      _buildTag('✨ ${show['category'] ?? 'Edukasi'} • ${show['seasons'] ?? '1 Musim'}', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                      _buildTag('⭐ ${show['rating'] ?? '9.0'}', const Color(0xFFFEF3C7), const Color(0xFFB45309)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    (show['title'] ?? '').toString(),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (show['description'] ?? '').toString(),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF475569), height: 1.45),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text('🌟 Pilih Episode Seru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
            const SizedBox(height: 10),
            ...List.generate(episodes.length, (index) {
              final isSelected = index == _activeEpisodeIndex;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () => _selectEpisode(index),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFEF9C3) : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFACC15) : const Color(0xFFBAE6FD),
                        width: 2.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFF97316) : const Color(0xFF0EA5E9),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            episodes[index],
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                          ),
                        ),
                        Icon(
                          Icons.play_circle_fill_rounded,
                          color: isSelected ? const Color(0xFFF97316) : const Color(0xFF0EA5E9),
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
      child: Text(label, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: textColor)),
    );
  }

  /// Helper mandiri untuk menentukan warna gradien & ikon berdasarkan kategori
  Map<String, dynamic> _resolveCategoryTheme(String? category) {
    switch (category) {
      case 'Petualangan':
        return {
          'gradients': [const Color(0xFF22D3EE), const Color(0xFF0EA5E9), const Color(0xFFFB923C)],
          'icon': Icons.rocket_launch_rounded,
        };
      case 'Edukasi':
        return {
          'gradients': [const Color(0xFF34D399), const Color(0xFF10B981), const Color(0xFF38BDF8)],
          'icon': Icons.auto_stories_rounded,
        };
      case 'Komedi':
        return {
          'gradients': [const Color(0xFFFDE047), const Color(0xFFFBBF24), const Color(0xFFFB923C)],
          'icon': Icons.sentiment_very_satisfied_rounded,
        };
      case 'Fantasi':
        return {
          'gradients': [const Color(0xFFF472B6), const Color(0xFFC084FC), const Color(0xFF818CF8)],
          'icon': Icons.auto_awesome_rounded,
        };
      default:
        return {
          'gradients': [const Color(0xFF38BDF8), const Color(0xFF0EA5E9), const Color(0xFF2DD4BF)],
          'icon': Icons.tv_rounded,
        };
    }
  }
}