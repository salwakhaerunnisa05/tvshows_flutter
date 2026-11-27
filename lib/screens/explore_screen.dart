import 'package:flutter/material.dart';
import '../data/tv_shows_data.dart';
import '../routes/app_routes.dart';
import '../services/tv_shows_service.dart';
import '../ui/ui/shows_poster_cards.dart';

/// Halaman Explore utama dengan Search, Hero Banner, Filter, & Tombol Plus (+) CRUD
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allShows = List<Map<String, dynamic>>.from(tvShowsData);
  bool _isLoading = true;
  bool _isConnectedToLaravel = false;

  String _selectedCategory = 'Semua';
  String _selectedChannel = 'Semua Saluran';
  String _searchQuery = '';
  bool _onlyFavorites = false;

  final Set<String> _favoriteIds = {'avatar', 'spongebob', 'mickey'};

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Semua', 'emoji': '🌈', 'bg': const Color(0xFF0EA5E9), 'text': Colors.white},
    {'label': 'Petualangan', 'emoji': '🚀', 'bg': const Color(0xFFFFEDD5), 'text': const Color(0xFF9A3412)},
    {'label': 'Edukasi', 'emoji': '🎨', 'bg': const Color(0xFFD1FAE5), 'text': const Color(0xFF065F46)},
    {'label': 'Komedi', 'emoji': '😂', 'bg': const Color(0xFFFEF3C7), 'text': const Color(0xFF92400E)},
    {'label': 'Fantasi', 'emoji': '🦄', 'bg': const Color(0xFFFCE7F3), 'text': const Color(0xFF9D174D)},
  ];

  final List<String> _channels = [
    'Semua Saluran',
    'Disney',
    'Nickelodeon',
    'Cartoon Network',
    'PBS Kids',
    'Kids Classics',
  ];

  @override
  void initState() {
    super.initState();
    _loadShowsFromLaravel();
  }

  Future<void> _loadShowsFromLaravel() async {
    setState(() => _isLoading = true);
    final result = await TvShowService.fetchTvShows();
    if (!mounted) return;
    setState(() {
      _allShows = List<Map<String, dynamic>>.from(result['shows']);
      _isConnectedToLaravel = result['isFromApi'] == true;
      _isLoading = false;
    });
  }

  String _getShowKey(Map<String, dynamic> show) {
    return (show['slug'] ?? show['id']).toString();
  }

  List<Map<String, dynamic>> get _filteredShows {
    return _allShows.where((show) {
      final matchCat =
          _selectedCategory == 'Semua' || show['category'] == _selectedCategory;
      final matchChannel = _selectedChannel == 'Semua Saluran' ||
          show['channel'] == _selectedChannel;
      final title = (show['title'] ?? '').toString().toLowerCase();
      final subtitle = (show['subtitle'] ?? '').toString().toLowerCase();
      final channel = (show['channel'] ?? '').toString().toLowerCase();
      final q = _searchQuery.toLowerCase();

      final matchSearch =
          title.contains(q) || subtitle.contains(q) || channel.contains(q);
      final matchFav = !_onlyFavorites || _favoriteIds.contains(_getShowKey(show));

      return matchCat && matchChannel && matchSearch && matchFav;
    }).toList();
  }

  void _toggleFavorite(Map<String, dynamic> show) {
    final key = _getShowKey(show);
    final title = (show['title'] ?? '').toString();
    setState(() {
      if (_favoriteIds.contains(key)) {
        _favoriteIds.remove(key);
        _showSnackBar('"$title" dihapus dari Favoritku');
      } else {
        _favoriteIds.add(key);
        _showSnackBar('Hore! "$title" masuk Favoritku! ❤️');
      }
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedCategory = 'Semua';
      _selectedChannel = 'Semua Saluran';
      _searchQuery = '';
      _onlyFavorites = false;
      _searchController.clear();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
        ),
        backgroundColor: const Color(0xFFFDE047),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openDetail(Map<String, dynamic> show) {
    final key = _getShowKey(show);
    Navigator.pushNamed(
      context,
      AppRoutes.detail,
      arguments: {
        'show': show,
        'isFavorite': _favoriteIds.contains(key),
        'onToggleFavorite': () => _toggleFavorite(show),
      },
    );
  }

  Future<void> _openCrudPage() async {
    await Navigator.pushNamed(context, AppRoutes.crud);
    _loadShowsFromLaravel();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shows = _filteredShows;
    final heroShow = _allShows.firstWhere(
      (s) => _getShowKey(s) == 'avatar',
      orElse: () => _allShows.isNotEmpty ? _allShows.first : tvShowsData.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 74,
        shape: const Border(bottom: BorderSide(color: Color(0xFFBAE6FD), width: 3)),
        title: GestureDetector(
          onTap: _resetFilters,
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFBBF24), Color(0xFFFB923C), Color(0xFFEC4899)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.sentiment_very_satisfied_rounded, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                      children: [
                        TextSpan(text: 'Toon', style: TextStyle(color: Color(0xFF0284C7))),
                        TextSpan(text: 'Verse', style: TextStyle(color: Color(0xFFF97316))),
                        TextSpan(text: '!', style: TextStyle(color: Color(0xFFEC4899))),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: _isConnectedToLaravel ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _isConnectedToLaravel ? 'Laravel API Terhubung' : 'Mode Data Lokal',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: _isConnectedToLaravel ? const Color(0xFF059669) : const Color(0xFFD97706),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loadShowsFromLaravel,
            tooltip: 'Muat Ulang dari Laravel API',
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0284C7)),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
            tooltip: 'Profil & Logout',
            icon: const Icon(Icons.account_circle_rounded, color: Color(0xFF0284C7)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: GestureDetector(
              onTap: () => setState(() => _onlyFavorites = !_onlyFavorites),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _onlyFavorites ? const Color(0xFFFBCFE8) : const Color(0xFFFCE7F3),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _onlyFavorites ? const Color(0xFFEC4899) : const Color(0xFFF9A8D4),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.favorite_rounded, color: Color(0xFFEC4899), size: 18),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEC4899),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_favoriteIds.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadShowsFromLaravel,
        color: const Color(0xFF0EA5E9),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                      decoration: InputDecoration(
                        hintText: 'Cari Thomas, SpongeBob, Sofia, Ben 10...',
                        hintStyle: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w700),
                        prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0284C7)),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.cancel_rounded, color: Color(0xFFF43F5E)),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Color(0xFFBAE6FD), width: 2.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Color(0xFFFB923C), width: 2.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildHeroBanner(heroShow),
                    const SizedBox(height: 20),
                    _buildFilterPanel(shows.length),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator(color: Color(0xFF0EA5E9))),
                ),
              )
            else if (shows.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: const Color(0xFF7DD3FC), width: 3),
                    ),
                    child: Column(
                      children: [
                        const Text('😮', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 10),
                        const Text('Yah, kartunnya belum ketemu!', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _resetFilters,
                          icon: const Icon(Icons.auto_awesome_rounded),
                          label: const Text('Tampilkan Semua Kartun'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 95),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.68,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final show = shows[index];
                      return ShowPosterCard(
                        show: show,
                        isFavorite: _favoriteIds.contains(_getShowKey(show)),
                        onTap: () => _openDetail(show),
                        onToggleFavorite: () => _toggleFavorite(show),
                      );
                    },
                    childCount: shows.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCrudPage,
        backgroundColor: const Color(0xFFFDE047),
        foregroundColor: const Color(0xFF451A03),
        icon: const Icon(Icons.add_circle_rounded, color: Color(0xFFEA580C), size: 26),
        label: const Text('Tambah Kartun', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
      ),
    );
  }

  Widget _buildHeroBanner(Map<String, dynamic> heroShow) {
    final isFav = _favoriteIds.contains(_getShowKey(heroShow));
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF38BDF8), Color(0xFF22D3EE), Color(0xFF2DD4BF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white, width: 3.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(color: const Color(0xFFFDE047), borderRadius: BorderRadius.circular(20)),
            child: const Text('👑 Kartun Paling Seru Minggu Ini!', style: TextStyle(color: Color(0xFF451A03), fontSize: 11.5, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 10),
          Text((heroShow['title'] ?? '').toString(), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text((heroShow['description'] ?? '').toString(), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _openDetail(heroShow),
                icon: const Icon(Icons.play_circle_fill_rounded, color: Color(0xFFEA580C)),
                label: const Text('Ayo Tonton!'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFDE047), foregroundColor: const Color(0xFF451A03)),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () => _toggleFavorite(heroShow),
                icon: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: const Color(0xFFDB2777), size: 18),
                label: Text(isFav ? 'Disukai!' : 'Suka', style: const TextStyle(color: Color(0xFFBE185D), fontWeight: FontWeight.w900)),
                style: OutlinedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.95)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel(int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFBAE6FD), width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('📺 Kartun Pilihan', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(color: const Color(0xFFFDE047), borderRadius: BorderRadius.circular(14)),
                    child: Text('$count Acara', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF451A03))),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(20)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedChannel,
                    isDense: true,
                    items: _channels.map((ch) => DropdownMenuItem(value: ch, child: Text(ch))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedChannel = val);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat['label'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat['label'] as String),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF0EA5E9) : cat['bg'] as Color,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Text(
                        '${cat['emoji']} ${cat['label']}',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          color: isSelected ? Colors.white : cat['text'] as Color,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}