import 'package:flutter/material.dart';

/// Helper untuk mengubah string HEX dari JSON Laravel (contoh: "#38BDF8") menjadi Color Flutter
Color parseHexColor(String? hexString, {Color fallback = const Color(0xFF0EA5E9)}) {
  if (hexString == null || hexString.isEmpty) return fallback;
  try {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  } catch (_) {
    return fallback;
  }
}

/// Helper untuk memetakan nama ikon string dari JSON Laravel menjadi IconData Flutter
IconData parseIconName(String? iconName) {
  switch (iconName) {
    case 'train':
      return Icons.train_rounded;
    case 'shapes':
      return Icons.category_rounded;
    case 'crown':
      return Icons.auto_awesome_rounded;
    case 'bolt':
      return Icons.bolt_rounded;
    case 'wind':
      return Icons.air_rounded;
    case 'medical':
      return Icons.medical_services_rounded;
    case 'paw':
      return Icons.pets_rounded;
    case 'rocket':
      return Icons.rocket_launch_rounded;
    case 'water':
      return Icons.scuba_diving_rounded;
    case 'castle':
      return Icons.castle_rounded;
    case 'heart':
      return Icons.favorite_rounded;
    case 'abc':
      return Icons.abc_rounded;
    case 'magic':
      return Icons.auto_fix_high_rounded;
    case 'watch':
      return Icons.watch_rounded;
    case 'burger':
      return Icons.lunch_dining_rounded;
    case 'science':
      return Icons.science_rounded;
    default:
      return Icons.tv_rounded;
  }
}

/// Data cadangan lokal dengan struktur key snake_case persis seperti JSON response Laravel
final List<Map<String, dynamic>> tvShowsData = [
  {
    'id': 1,
    'slug': 'thomas',
    'title': 'Thomas the Train',
    'subtitle': 'Kereta Api Pulau Sodor',
    'channel': 'Kids Classics',
    'category': 'Edukasi',
    'rating': '8.7',
    'seasons': '24 Musim',
    'image_url': 'https://placehold.co/600x800/0284C7/FFFFFF.png?text=Thomas+%26+Friends',
    'gradient_colors': ['#38BDF8', '#3B82F6', '#EF4444'],
    'border_color': '#7DD3FC',
    'badge_color': '#EF4444',
    'badge_text_color': '#FFFFFF',
    'icon_name': 'train',
    'description':
        'Ayo naik kereta api biru nomor 1 bersama Thomas, Percy, dan James di Pulau Sodor! Belajar bekerja sama dan saling membantu teman.',
    'episodes': [
      'Thomas & Gordon',
      'Percy Kabur dari Stasiun',
      'James Si Kereta Merah',
      'Balapan Besar Sodor',
    ],
  },
  {
    'id': 2,
    'slug': 'mickey',
    'title': 'Mickey Mouse Clubhouse',
    'subtitle': 'Rumah Ajaib Mickey',
    'channel': 'Disney',
    'category': 'Edukasi',
    'rating': '8.9',
    'seasons': '4 Musim',
    'image_url': 'https://placehold.co/600x800/2563EB/FACC15.png?text=Mickey+Mouse+Clubhouse',
    'gradient_colors': ['#60A5FA', '#38BDF8', '#FDE047'],
    'border_color': '#FDE047',
    'badge_color': '#2563EB',
    'badge_text_color': '#FFFFFF',
    'icon_name': 'shapes',
    'description':
        'Miska, Muska, Mickey Mouse! Ayo berhitung dan memecahkan teka-teki bersama Mickey, Minnie, Donald, dan Goofy dibantu Toodles!',
    'episodes': [
      'Domba-Domba Daisy',
      'Kejutan Ulang Tahun Minnie',
      'Goofy Pergi ke Mars',
      'Berburu Harta Clubhouse',
    ],
  },
  {
    'id': 3,
    'slug': 'sofia',
    'title': 'Sofia the First',
    'subtitle': 'Putri Kerajaan Enchancia',
    'channel': 'Disney',
    'category': 'Fantasi',
    'rating': '9.0',
    'seasons': '4 Musim',
    'image_url': 'https://placehold.co/600x800/9333EA/FBCFE8.png?text=Sofia+the+First',
    'gradient_colors': ['#C084FC', '#E879F9', '#F472B6'],
    'border_color': '#F9A8D4',
    'badge_color': '#9333EA',
    'badge_text_color': '#FFFFFF',
    'icon_name': 'crown',
    'description':
        'Sofia menjadi putri kerajaan yang baik hati dan bisa berbicara dengan hewan-hewan hutan yang lucu berkat kalung jimat ajaib Avalor!',
    'episodes': [
      'Awal Kisah Sang Putri',
      'Jimat Ajaib Avalor',
      'Istana Terapung',
      'Pesta Dansa Kerajaan',
    ],
  },
  {
    'id': 4,
    'slug': 'pokemon',
    'title': 'Pokémon: Black & White',
    'subtitle': 'Petualangan Ash & Pikachu',
    'channel': 'Cartoon Network',
    'category': 'Petualangan',
    'rating': '9.3',
    'seasons': '3 Musim',
    'image_url': 'https://placehold.co/600x800/F59E0B/1E293B.png?text=Pokemon+Black+%26+White',
    'gradient_colors': ['#FBBF24', '#FACC15', '#0EA5E9'],
    'border_color': '#FCD34D',
    'badge_color': '#0F172A',
    'badge_text_color': '#FDE047',
    'icon_name': 'bolt',
    'description':
        'Pika-Pika! Ikuti Ash dan Pikachu menjelajahi wilayah baru Unova bersama Iris dan Cilan untuk bertemu banyak Pokémon lucu dan kuat!',
    'episodes': [
      'Bayangan Zekrom!',
      'Berkenalan dengan Iris & Axew!',
      'Petualangan Bawah Tanah!',
      'Pertarungan Gym Unova!',
    ],
  },
  {
    'id': 5,
    'slug': 'avatar',
    'title': 'Avatar: The Last Airbender',
    'subtitle': 'Pengendali Empat Elemen',
    'channel': 'Nickelodeon',
    'category': 'Petualangan',
    'rating': '9.8',
    'seasons': '3 Musim',
    'image_url': 'https://placehold.co/600x800/0EA5E9/FEF08A.png?text=Avatar+The+Last+Airbender',
    'gradient_colors': ['#22D3EE', '#0EA5E9', '#FB923C'],
    'border_color': '#67E8F9',
    'badge_color': '#F97316',
    'badge_text_color': '#FFFFFF',
    'icon_name': 'wind',
    'description':
        'Aang si pengendali udara terbang bersama Appa dan Momo untuk belajar mengendalikan air, tanah, dan api demi kedamaian dunia!',
    'episodes': [
      'Anak di Dalam Gunung Es',
      'Kembalinya Sang Avatar',
      'Prajurit Pulau Kyoshi',
      'Komet Sozin',
    ],
  },
  {
    'id': 6,
    'slug': 'doc',
    'title': 'Doc McStuffins',
    'subtitle': 'Dokter Mainan Cilik',
    'channel': 'Disney',
    'category': 'Edukasi',
    'rating': '8.8',
    'seasons': '5 Musim',
    'image_url': 'https://placehold.co/600x800/EC4899/FFFFFF.png?text=Doc+McStuffins',
    'gradient_colors': ['#F472B6', '#C084FC', '#38BDF8'],
    'border_color': '#D8B4FE',
    'badge_color': '#EC4899',
    'badge_text_color': '#FFFFFF',
    'icon_name': 'medical',
    'description':
        'Dengan stetoskop ajaibnya, Doc bisa menghidupkan boneka dan mainan agar bisa memeriksa kesehatan mereka di klinik halaman belakang!',
    'episodes': [
      'Waktunya Ksatria',
      'Landak yang Bersin',
      'Keluar dari Kotak Mainan',
      'Rumah Sakit Mainan',
    ],
  },
  {
    'id': 7,
    'slug': 'wildkratts',
    'title': 'Wild Kratts',
    'subtitle': 'Kekuatan Sahabat Satwa',
    'channel': 'PBS Kids',
    'category': 'Petualangan',
    'rating': '9.1',
    'seasons': '7 Musim',
    'image_url': 'https://placehold.co/600x800/10B981/ECFDF5.png?text=Wild+Kratts',
    'gradient_colors': ['#34D399', '#22C55E', '#14B8A6'],
    'border_color': '#6EE7B7',
    'badge_color': '#059669',
    'badge_text_color': '#FFFFFF',
    'icon_name': 'paw',
    'description':
        'Chris dan Martin Kratt memakai baju kekuatan hewan canggih untuk berenang seperti lumba-lumba dan berlari secepat cheetah!',
    'episodes': [
      'Ibu Buaya yang Hebat',
      'Paus dan Cumi Raksasa',
      'Balapan Lari Cheetah',
      'Perjalanan Kupu-Kupu',
    ],
  },
  {
    'id': 8,
    'slug': 'phineas',
    'title': 'Phineas and Ferb',
    'subtitle': 'Penemu Cilik Kreatif',
    'channel': 'Disney',
    'category': 'Komedi',
    'rating': '9.5',
    'seasons': '4 Musim',
    'image_url': 'https://placehold.co/600x800/06B6D4/FFF7ED.png?text=Phineas+and+Ferb',
    'gradient_colors': ['#22D3EE', '#38BDF8', '#FB923C'],
    'border_color': '#FDBA74',
    'badge_color': '#F97316',
    'badge_text_color': '#FFFFFF',
    'icon_name': 'rocket',
    'description':
        'Setiap hari libur, Phineas dan Ferb membuat wahana super keren di halaman rumah, sementara Perry si platipus menjadi agen rahasia!',
    'episodes': [
      'Rollercoaster Raksasa',
      'Pesta Pantai Halaman Rumah',
      'Keliling Dunia Sehari!',
      'Mesin Waktu Seru',
    ],
  },
  {
    'id': 9,
    'slug': 'octonauts',
    'title': 'Octonauts',
    'subtitle': 'Penjelajah Bawah Laut',
    'channel': 'Disney',
    'category': 'Edukasi',
    'rating': '9.0',
    'seasons': '5 Musim',
    'image_url': 'https://placehold.co/600x800/0D9488/CCFBF1.png?text=Octonauts',
    'gradient_colors': ['#2DD4BF', '#06B6D4', '#3B82F6'],
    'border_color': '#5EEAD4',
    'badge_color': '#F97316',
    'badge_text_color': '#FFFFFF',
    'icon_name': 'water',
    'description':
        'Bunyikan Octo-Alert! Kapten Barnacles, Kwazii, dan Peso menyelam ke dasar laut untuk menolong ikan-ikan dan hewan laut yang lucu.',
    'episodes': [
      'Badai Bawah Laut',
      'Hiu Paus Raksasa',
      'Cumi-Cumi Raksasa',
      'Petualangan Palung Laut',
    ],
  },
  {
    'id': 10,
    'slug': 'adventuretime',
    'title': 'Adventure Time',
    'subtitle': 'Petualangan Finn & Jake',
    'channel': 'Cartoon Network',
    'category': 'Fantasi',
    'rating': '9.4',
    'seasons': '10 Musim',
    'image_url': 'https://placehold.co/600x800/38BDF8/FEF08A.png?text=Adventure+Time',
    'gradient_colors': ['#38BDF8', '#34D399', '#FDE047'],
    'border_color': '#BEF264',
    'badge_color': '#0EA5E9',
    'badge_text_color': '#FFFFFF',
    'icon_name': 'castle',
    'description':
        'Finn si anak pemberani dan anjing ajaibnya Jake yang bisa melar berkeliling Tanah Ooo untuk menolong Putri Permen Karet!',
    'episodes': [
      'Pesta Piyama Seru',
      'Kerajaan Permen Karet',
      'Pedang Ajaib Finn',
      'Petualangan Rumah Pohon',
    ],
  },
  {
    'id': 11,
    'slug': 'danieltiger',
    'title': "Daniel Tiger's Neighborhood",
    'subtitle': 'Bernyanyi Bersama Daniel',
    'channel': 'PBS Kids',
    'category': 'Edukasi',
    'rating': '8.8',
    'seasons': '6 Musim',
    'image_url': 'https://placehold.co/600x800/EF4444/FEF3C7.png?text=Daniel+Tiger',
    'gradient_colors': ['#38BDF8', '#FCD34D', '#F87171'],
    'border_color': '#FCA5A5',
    'badge_color': '#EF4444',
    'badge_text_color': '#FFFFFF',
    'icon_name': 'heart',
    'description':
        'Ugga Mugga! Daniel Tiger mengajak teman-teman kecil bernyanyi riang sambil belajar berbagi, sabar, dan menyayangi keluarga.',
    'episodes': [
      'Ulang Tahun Daniel',
      'Hari Pertama Sekolah',
      'Berbagi Buku di Perpustakaan',
      'Adik Baru Daniel',
    ],
  },
  {
    'id': 12,
    'slug': 'sesamestreet',
    'title': 'Sesame Street',
    'subtitle': 'Jalan Ceria 123',
    'channel': 'PBS Kids',
    'category': 'Edukasi',
    'rating': '9.2',
    'seasons': '50+ Musim',
    'image_url': 'https://placehold.co/600x800/16A34A/FEF08A.png?text=Sesame+Street+123',
    'gradient_colors': ['#34D399', '#22C55E', '#FDE047'],
    'border_color': '#86EFAC',
    'badge_color': '#16A34A',
    'badge_text_color': '#FEF08A',
    'icon_name': 'abc',
    'description':
        'Elmo, Cookie Monster yang suka kue, dan Big Bird mengajakmu belajar huruf ABC dan angka 123 sambil tertawa bersama!',
    'episodes': [
      'Dunia Elmo: Musik',
      'Truk Kue Cookie Monster',
      'Sarang Besar Big Bird',
      'Berhitung Bersama Count',
    ],
  },
  {
    'id': 13,
    'slug': 'mlp',
    'title': 'My Little Pony: Friendship is Magic',
    'subtitle': 'Keajaiban Persahabatan',
    'channel': 'Kids Classics',
    'category': 'Fantasi',
    'rating': '9.1',
    'seasons': '9 Musim',
    'image_url': 'https://placehold.co/600x800/F472B6/FDF2F8.png?text=My+Little+Pony',
    'gradient_colors': ['#F472B6', '#C084FC', '#818CF8'],
    'border_color': '#F9A8D4',
    'badge_color': '#EC4899',
    'badge_text_color': '#FFFFFF',
    'icon_name': 'magic',
    'description':
        'Twilight Sparkle, Rainbow Dash, dan Pinkie Pie berpetualang di dunia penuh pelangi Equestria untuk menyebarkan kebahagiaan!',
    'episodes': [
      'Persahabatan Itu Ajaib',
      'Pelangi Sonic Rainboom',
      'Pesta Kue Pinkie Pie',
      'Festival Musim Panas',
    ],
  },
  {
    'id': 14,
    'slug': 'ben10',
    'title': 'Ben 10',
    'subtitle': 'Pahlawan Jam Omnitrix',
    'channel': 'Cartoon Network',
    'category': 'Petualangan',
    'rating': '9.2',
    'seasons': '4 Musim',
    'image_url': 'https://placehold.co/600x800/65A30D/ECFCCB.png?text=BEN+10',
    'gradient_colors': ['#A3E635', '#10B981', '#0D9488'],
    'border_color': '#BEF264',
    'badge_color': '#A3E635',
    'badge_text_color': '#0F172A',
    'icon_name': 'watch',
    'description':
        'Saatnya jadi pahlawan! Ben Tennyson bisa berubah menjadi 10 alien super keren dengan jam tangan Omnitrix untuk melindungi bumi!',
    'episodes': [
      'Awal Mula 10 Alien',
      'Petualangan Musim Panas',
      'Kekuatan Four Arms',
      'Rahasia Jam Omnitrix',
    ],
  },
  {
    'id': 15,
    'slug': 'spongebob',
    'title': 'SpongeBob SquarePants',
    'subtitle': 'Ceria di Bikini Bottom',
    'channel': 'Nickelodeon',
    'category': 'Komedi',
    'rating': '9.6',
    'seasons': '14 Musim',
    'image_url': 'https://placehold.co/600x800/FACC15/1E3A8A.png?text=SpongeBob+SquarePants',
    'gradient_colors': ['#FDE047', '#FBBF24', '#38BDF8'],
    'border_color': '#FDE047',
    'badge_color': '#FDE047',
    'badge_text_color': '#451A03',
    'icon_name': 'burger',
    'description':
        'Siapa yang tinggal di nanas di bawah laut? SpongeBob! Ayo tertawa bersama Patrick Star, siput Gary, dan memasak Krabby Patty!',
    'episodes': [
      'Lowongan Pekerjaan',
      'Konser Musik Bikini Bottom',
      'Antar Pesanan Pizza',
      'Berburu Ubur-Ubur',
    ],
  },
  {
    'id': 16,
    'slug': 'sid',
    'title': 'Sid the Science Kid',
    'subtitle': 'Ilmuwan Cilik Penasaran',
    'channel': 'PBS Kids',
    'category': 'Edukasi',
    'rating': '8.6',
    'seasons': '2 Musim',
    'image_url': 'https://placehold.co/600x800/F97316/FFFBEB.png?text=Sid+the+Science+Kid',
    'gradient_colors': ['#FBBF24', '#FB923C', '#38BDF8'],
    'border_color': '#FCD34D',
    'badge_color': '#EF4444',
    'badge_text_color': '#FFFFFF',
    'icon_name': 'science',
    'description':
        'Kenapa ya es bisa mencair? Sid selalu punya banyak pertanyaan seru dan melakukan percobaan sains menyenangkan bersama teman-temannya!',
    'episodes': [
      'Papan Stiker Sid',
      'Rahasia Es Mencair',
      'Mencari Kerang di Pantai',
      'Belajar Tentang Paus',
    ],
  },
];