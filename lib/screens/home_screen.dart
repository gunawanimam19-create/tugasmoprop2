import 'package:flutter/material.dart';
import '../state/canteen_state.dart';
import '../theme/app_theme.dart';
import '../widgets/promo_banner.dart';
import '../widgets/menu_card.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onTabChange;

  const HomeScreen({super.key, required this.onTabChange});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'Semua',
    'Makanan Berat',
    'Camilan / Snack',
    'Minuman Segar',
    'Paket Hemat',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showTopUpDialog(BuildContext context, CanteenState state) {
    int selectedAmount = 20000;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.account_balance_wallet_rounded, color: AppTheme.primaryOrange),
              SizedBox(width: 8),
              Text('Top Up Saldo Kantin', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pilih nominal isi ulang:', style: TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [10000, 20000, 50000, 100000].map((nominal) {
                  final isSelected = selectedAmount == nominal;
                  return ChoiceChip(
                    label: Text(AppTheme.formatRupiah(nominal)),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryOrange,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (val) {
                      if (val) setDialogState(() => selectedAmount = nominal);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.qr_code_scanner, color: AppTheme.primaryOrange),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Metode: QRIS Instant', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('Bebas biaya admin transfer', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                state.topUpWallet(selectedAmount);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Top up ${AppTheme.formatRupiah(selectedAmount)} berhasil!'),
                    backgroundColor: AppTheme.secondaryGreen,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Isi Saldo'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = CanteenScope.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final popularItems = state.menuItems.where((m) => m.isPopular).toList();

    return Scaffold(
      body: RefreshIndicator(
        color: AppTheme.primaryOrange,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 600));
          setState(() {});
        },
        child: CustomScrollView(
          slivers: [
            // App Bar with Greeting & User Info
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 130,
              backgroundColor: isDark ? AppTheme.cardDark : Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                  bottom: false,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppTheme.primaryOrange.withOpacity(0.15),
                          child: const Text(
                            'IM',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryOrange,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Hai, ${state.userName}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.verified, color: Colors.blue, size: 16),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Mau makan apa di Kantin Bu Sari hari ini?',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      IconButton(
                        icon: const Badge(
                          label: Text('2'),
                          child: Icon(Icons.notifications_outlined),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Notifikasi: Promo hemat makan siang sudah aktif!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

            // Main Body Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // Wallet & Points Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      color: isDark ? AppTheme.cardDark : AppTheme.warmCream,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: AppTheme.primaryOrange.withOpacity(0.3),
                          width: 1.2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryOrange.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.account_balance_wallet, color: AppTheme.primaryOrange),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Saldo Kantin Pay',
                                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                  ),
                                  Text(
                                    AppTheme.formatRupiah(state.walletBalance),
                                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 30,
                              width: 1,
                              color: Colors.grey.withOpacity(0.3),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Poin Loyalitas', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                                Row(
                                  children: [
                                    const Icon(Icons.stars_rounded, color: Colors.amber, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${state.userPoints} Pts',
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () => _showTopUpDialog(context, state),
                              child: const Text('Top Up', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar (TextField)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari ayam geprek, nasi goreng, es teh...',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                        prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryOrange),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  state.setSearchQuery('');
                                },
                              )
                            : null,
                      ),
                      onChanged: (val) => state.setSearchQuery(val),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Promo Banners (PageView with indicators)
                  const PromoBanner(),
                  const SizedBox(height: 18),

                  // Category Selector Chips
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Kategori Menu',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: () => widget.onTabChange(1), // Go to catalog tab
                          child: const Row(
                            children: [
                              Text('Lihat Semua', style: TextStyle(fontSize: 12, color: AppTheme.primaryOrange)),
                              Icon(Icons.arrow_forward_ios, size: 12, color: AppTheme.primaryOrange),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 42,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = state.selectedCategory == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: AppTheme.primaryOrange,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : (isDark ? Colors.grey[300] : Colors.grey[800]),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                          onSelected: (val) {
                            if (val) state.setCategory(cat);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Rekomendasi Spesial Bu Sari (Horizontal Scroll)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.whatshot_rounded, color: AppTheme.accentRed, size: 22),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text(
                            'Paling Banyak Dipesan',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('Rekomendasi Bu Sari', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 190,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: popularItems.length,
                      itemBuilder: (context, index) {
                        return MenuCard(item: popularItems[index], isHorizontalCompact: true);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Menu List Sesuai Filter
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            state.selectedCategory == 'Semua' ? 'Daftar Menu Favorit' : 'Menu: ${state.selectedCategory}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${state.filteredMenuItems.length} Menu',
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // List of Filtered Items
                  if (state.filteredMenuItems.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(40),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          const Text(
                            'Menu tidak ditemukan',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Coba kata kunci lain atau ganti filter kategori.',
                            style: TextStyle(color: Colors.grey[500], fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.filteredMenuItems.length,
                      itemBuilder: (context, index) {
                        return MenuCard(item: state.filteredMenuItems[index]);
                      },
                    ),

                  const SizedBox(height: 80), // Padding for floating bar
                ],
              ),
            ),
          ],
        ),
      ),
      // Floating Bottom Cart Bar
      bottomSheet: state.cartCount > 0
          ? Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                child: InkWell(
                  onTap: () => widget.onTabChange(2), // Go to Cart tab
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primaryOrange, AppTheme.primaryOrangeLight],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.shopping_basket_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${state.cartCount} Item dalam Keranjang',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            Text(
                              AppTheme.formatRupiah(state.cartTotal),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Text(
                          'Checkout',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
