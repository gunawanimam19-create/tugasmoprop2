import 'package:flutter/material.dart';
import '../state/canteen_state.dart';
import '../theme/app_theme.dart';
import '../widgets/menu_card.dart';

class MenuCatalogScreen extends StatefulWidget {
  const MenuCatalogScreen({super.key});

  @override
  State<MenuCatalogScreen> createState() => _MenuCatalogScreenState();
}

class _MenuCatalogScreenState extends State<MenuCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = false;

  final List<String> _categories = [
    'Semua',
    'Makanan Berat',
    'Camilan / Snack',
    'Minuman Segar',
    'Paket Hemat',
  ];

  final List<String> _sortOptions = [
    'Terpopuler',
    'Harga Terendah',
    'Harga Tertinggi',
    'Rating Tertinggi',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = CanteenScope.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final items = state.filteredMenuItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Menu Kantin'),
        actions: [
          // Toggle Grid vs List View
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
            tooltip: _isGridView ? 'Tampilan Baris' : 'Tampilan Grid',
            onPressed: () {
              setState(() => _isGridView = !_isGridView);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Sort Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            color: isDark ? AppTheme.cardDark : Colors.white,
            child: Column(
              children: [
                // Search Input Field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari menu favorit kamu...',
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
                    isDense: true,
                  ),
                  onChanged: (val) => state.setSearchQuery(val),
                ),
                const SizedBox(height: 10),

                // Category Chips Scroll
                SizedBox(
                  height: 38,
                  child: ListView.separated(
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
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 12,
                        ),
                        onSelected: (val) {
                          if (val) state.setCategory(cat);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Sort Dropdown & Item Counter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menampilkan ${items.length} menu',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.sort_rounded, size: 16, color: AppTheme.primaryOrange),
                        const SizedBox(width: 4),
                        DropdownButton<String>(
                          value: state.selectedSort,
                          underline: const SizedBox(),
                          isDense: true,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          items: _sortOptions.map((opt) {
                            return DropdownMenuItem<String>(
                              value: opt,
                              child: Text(opt),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) state.setSort(val);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Menu Items List / Grid
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.no_meals_rounded, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        const Text(
                          'Menu tidak ditemukan',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Coba ubah kata pencarian atau pilih kategori lain.',
                          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : _isGridView
                    ? GridView.builder(
                        padding: const EdgeInsets.all(14),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.82,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return MenuCard(item: items[index], isHorizontalCompact: true);
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return MenuCard(item: items[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
