import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constant.dart';
import '../services/auth_service.dart';
import '../services/tv_shows_service.dart';

/// Halaman CRUD Lengkap (Tambah, Edit, dan Hapus Kartun di Laravel API)
class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  final _titleCtrl = TextEditingController();
  final _subtitleCtrl = TextEditingController();
  final _channelCtrl = TextEditingController(text: 'Nickelodeon');
  final _categoryCtrl = TextEditingController(text: 'Petualangan');
  final _imageCtrl = TextEditingController(
    text: 'https://placehold.co/600x800/0EA5E9/FFFFFF.png?text=Kartun+Baru',
  );
  final _descCtrl = TextEditingController();
  final _episodeCtrl = TextEditingController(text: 'Episode 1: Petualangan Dimulai');

  List<Map<String, dynamic>> _shows = [];
  int? _editingId;
  bool _isSaving = false;
  bool _isLoadingList = true;

  @override
  void initState() {
    super.initState();
    _fetchList();
  }

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
      };

  Future<void> _fetchList() async {
    setState(() => _isLoadingList = true);
    final res = await TvShowService.fetchTvShows();
    if (!mounted) return;
    setState(() {
      _shows = List<Map<String, dynamic>>.from(res['shows']);
      _isLoadingList = false;
    });
  }

  void _startEdit(Map<String, dynamic> show) {
    final eps = (show['episodes'] as List<dynamic>?) ?? [];
    setState(() {
      _editingId = show['id'] is int ? show['id'] : int.tryParse('${show['id']}');
      _titleCtrl.text = (show['title'] ?? '').toString();
      _subtitleCtrl.text = (show['subtitle'] ?? '').toString();
      _channelCtrl.text = (show['channel'] ?? 'Nickelodeon').toString();
      _categoryCtrl.text = (show['category'] ?? 'Petualangan').toString();
      _imageCtrl.text = (show['image_url'] ?? '').toString();
      _descCtrl.text = (show['description'] ?? '').toString();
      _episodeCtrl.text = eps.isNotEmpty ? eps.first.toString() : 'Episode 1';
    });
  }

  void _resetForm() {
    setState(() {
      _editingId = null;
      _titleCtrl.clear();
      _subtitleCtrl.clear();
      _descCtrl.clear();
    });
  }

  Future<void> _saveShow() async {
    if (_titleCtrl.text.trim().isEmpty) return;
    setState(() => _isSaving = true);

    final payload = jsonEncode({
      'title': _titleCtrl.text.trim(),
      'subtitle': _subtitleCtrl.text.trim().isEmpty ? 'Serial Anak' : _subtitleCtrl.text.trim(),
      'channel': _channelCtrl.text.trim(),
      'category': _categoryCtrl.text.trim(),
      'rating': '9.2',
      'seasons': '1 Musim',
      'image_url': _imageCtrl.text.trim(),
      'description': _descCtrl.text.trim().isEmpty
          ? 'Serial animasi seru untuk anak-anak.'
          : _descCtrl.text.trim(),
      'episodes': [_episodeCtrl.text.trim()],
    });

    try {
      final response = _editingId == null
          ? await http.post(Uri.parse(ApiConstant.tvShowsEndpoint), headers: _headers, body: payload)
          : await http.put(Uri.parse('${ApiConstant.tvShowsEndpoint}/$_editingId'), headers: _headers, body: payload);

      if (!mounted) return;
      setState(() => _isSaving = false);

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_editingId == null ? '🎉 Kartun ditambahkan!' : '✅ Kartun diperbarui!')),
        );
        _resetForm();
        _fetchList();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal (${response.statusCode}): pastikan sudah login!')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _deleteShow(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstant.tvShowsEndpoint}/$id'),
        headers: _headers,
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🗑️ Kartun berhasil dihapus!')),
        );
        _fetchList();
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _subtitleCtrl.dispose();
    _channelCtrl.dispose();
    _categoryCtrl.dispose();
    _imageCtrl.dispose();
    _descCtrl.dispose();
    _episodeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(
        title: Text(_editingId == null ? '➕ Tambah & Kelola Kartun' : '✏️ Edit Kartun'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF7DD3FC), width: 2.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Judul Kartun')),
                  const SizedBox(height: 10),
                  TextField(controller: _subtitleCtrl, decoration: const InputDecoration(labelText: 'Subjudul')),
                  const SizedBox(height: 10),
                  TextField(controller: _channelCtrl, decoration: const InputDecoration(labelText: 'Channel TV')),
                  const SizedBox(height: 10),
                  TextField(controller: _categoryCtrl, decoration: const InputDecoration(labelText: 'Kategori')),
                  const SizedBox(height: 10),
                  TextField(controller: _imageCtrl, decoration: const InputDecoration(labelText: 'URL Poster')),
                  const SizedBox(height: 10),
                  TextField(controller: _descCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Deskripsi')),
                  const SizedBox(height: 10),
                  TextField(controller: _episodeCtrl, decoration: const InputDecoration(labelText: 'Episode 1')),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isSaving ? null : _saveShow,
                          icon: Icon(_editingId == null ? Icons.add_rounded : Icons.save_rounded),
                          label: Text(_isSaving
                              ? 'Menyimpan...'
                              : (_editingId == null ? 'Tambah Kartun' : 'Simpan Perubahan')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFDE047),
                            foregroundColor: const Color(0xFF451A03),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      if (_editingId != null) ...[
                        const SizedBox(width: 8),
                        TextButton(onPressed: _resetForm, child: const Text('Batal')),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('📋 Daftar Kartun di Database (Edit / Hapus)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            if (_isLoadingList)
              const Center(child: CircularProgressIndicator())
            else
              ..._shows.map((show) {
                final id = show['id'] is int ? show['id'] as int : int.tryParse('${show['id']}');
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: ListTile(
                    title: Text((show['title'] ?? '').toString(), style: const TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: Text('${show['channel']} • ${show['category']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_rounded, color: Color(0xFF0284C7)),
                          onPressed: () => _startEdit(show),
                        ),
                        if (id != null)
                          IconButton(
                            icon: const Icon(Icons.delete_rounded, color: Color(0xFFF43F5E)),
                            onPressed: () => _deleteShow(id),
                          ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}