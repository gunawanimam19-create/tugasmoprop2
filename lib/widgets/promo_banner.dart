import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _promos = [
    {
      'title': 'Diskon Mahasiswa 15%!',
      'subtitle': 'Pakai kupon DISKONMHS saat checkout di kantin',
      'tag': 'Spesial Kampus',
      'color1': const Color(0xFFE65100),
      'color2': const Color(0xFFFF8A50),
      'icon': Icons.local_offer_rounded,
    },
    {
      'title': 'Paket Sarapan Hemat Rp 15rb',
      'subtitle': 'Nasi Uduk + Telur Balado + Bakwan + Teh Hangat',
      'tag': 'Pagi Ceria',
      'color1': const Color(0xFF00897B),
      'color2': const Color(0xFF4DB6AC),
      'icon': Icons.wb_sunny_rounded,
    },
    {
      'title': 'Bebas Antre Pakai Saldo Kantin',
      'subtitle': 'Pesan dari kelas, makanan siap saat kamu sampai di kantin!',
      'tag': 'Cepat & Praktis',
      'color1': const Color(0xFF6A1B9A),
      'color2': const Color(0xFFAB47BC),
      'icon': Icons.flash_on_rounded,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemCount: _promos.length,
            itemBuilder: (context, index) {
              final promo = _promos[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [promo['color1'] as Color, promo['color2'] as Color],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: (promo['color1'] as Color).withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              promo['tag'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            promo['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            promo['subtitle'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(promo['icon'], color: Colors.white, size: 30),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_promos.length, (index) {
            final isActive = _currentPage == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: isActive ? 20 : 6,
              decoration: BoxDecoration(
                color: isActive ? AppTheme.primaryOrange : Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
