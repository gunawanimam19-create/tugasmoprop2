import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/cart_item.dart';
import '../theme/app_theme.dart';
import '../state/canteen_state.dart';

class MenuDetailSheet extends StatefulWidget {
  final MenuItem item;

  const MenuDetailSheet({super.key, required this.item});

  static Future<void> show(BuildContext context, MenuItem item) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => MenuDetailSheet(item: item),
    );
  }

  @override
  State<MenuDetailSheet> createState() => _MenuDetailSheetState();
}

class _MenuDetailSheetState extends State<MenuDetailSheet> {
  int _quantity = 1;
  double _spicyLevel = 1.0;
  String _selectedPortion = 'Reguler';
  final Set<ToppingOption> _selectedToppings = {};
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  int get _calculatedUnitPrice {
    int price = widget.item.discountedPrice;
    if (_selectedPortion == 'Jumbo') {
      price += 4000;
    }
    for (final top in _selectedToppings) {
      price += top.price;
    }
    return price;
  }

  int get _calculatedTotalPrice => _calculatedUnitPrice * _quantity;

  String _getSpicyDescription(int level) {
    switch (level) {
      case 0:
        return 'Tidak Pedas (Manis / Gurih)';
      case 1:
        return 'Level 1: Pedas Santai';
      case 2:
        return 'Level 2: Pedas Sedang';
      case 3:
        return 'Level 3: Pedas Nampol';
      case 4:
        return 'Level 4: Super Pedas';
      case 5:
        return 'Level 5: Api Neraka 🔥';
      default:
        return 'Level $level';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image & Hero Banner
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Image.network(
                          widget.item.imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 200,
                            color: isDark ? Colors.grey[800] : const Color(0xFFFFE0B2),
                            child: const Center(
                              child: Icon(Icons.fastfood_rounded, size: 64, color: AppTheme.primaryOrange),
                            ),
                          ),
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              height: 200,
                              color: isDark ? Colors.grey[850] : Colors.grey[200],
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          },
                        ),
                        if (widget.item.isPromo)
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppTheme.accentRed,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'HEMAT ${widget.item.discountPercent}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title & Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.item.name,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.item.rating} (${widget.item.reviewCount})',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Category & Price
                  Row(
                    children: [
                      Chip(
                        label: Text(widget.item.category),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: AppTheme.primaryOrange.withOpacity(0.1),
                        labelStyle: const TextStyle(
                          color: AppTheme.primaryOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (widget.item.isPromo) ...[
                        Text(
                          AppTheme.formatRupiah(widget.item.price),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        AppTheme.formatRupiah(widget.item.discountedPrice),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    widget.item.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                  const Divider(height: 32),

                  // Portion Selector (RadioListTile)
                  const Text(
                    'Pilihan Porsi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Card(
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          value: 'Reguler',
                          groupValue: _selectedPortion,
                          title: const Text('Porsi Standar / Reguler'),
                          subtitle: const Text('Porsi pas untuk makan santai'),
                          activeColor: AppTheme.primaryOrange,
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedPortion = val);
                          },
                        ),
                        const Divider(height: 1),
                        RadioListTile<String>(
                          value: 'Jumbo',
                          groupValue: _selectedPortion,
                          title: const Text('Porsi Jumbo Kenyang (+Rp 4.000)'),
                          subtitle: const Text('Ekstra nasi & lauk lebih banyak'),
                          activeColor: AppTheme.primaryOrange,
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedPortion = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Spicy Level Slider
                  if (widget.item.spicyLevelAvailable) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tingkat Kepedasan',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _getSpicyDescription(_spicyLevel.round()),
                          style: const TextStyle(
                            color: AppTheme.accentRed,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _spicyLevel,
                      min: 0,
                      max: 5,
                      divisions: 5,
                      label: 'Level ${_spicyLevel.round()}',
                      activeColor: AppTheme.accentRed,
                      inactiveColor: Colors.grey.withOpacity(0.3),
                      onChanged: (val) {
                        setState(() => _spicyLevel = val);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Toppings (CheckboxListTile)
                  if (widget.item.availableToppings.isNotEmpty) ...[
                    const Text(
                      'Tambahan Lauk & Topping (Opsional)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Column(
                        children: widget.item.availableToppings.map((top) {
                          final isSelected = _selectedToppings.contains(top);
                          return CheckboxListTile(
                            value: isSelected,
                            title: Text(top.name),
                            subtitle: Text(
                              top.price == 0 ? 'Gratis' : '+${AppTheme.formatRupiah(top.price)}',
                              style: const TextStyle(
                                color: AppTheme.primaryOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            activeColor: AppTheme.primaryOrange,
                            onChanged: (checked) {
                              setState(() {
                                if (checked == true) {
                                  _selectedToppings.add(top);
                                } else {
                                  _selectedToppings.remove(top);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Notes (TextFormField)
                  const Text(
                    'Catatan Khusus untuk Bu Sari',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Jangan pakai daun bawang, kuah dipisah, dll.',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                      prefixIcon: const Icon(Icons.edit_note_rounded),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardTheme.color ?? theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Quantity Stepper
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 18),
                          onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                        ),
                        Text(
                          '$_quantity',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () => setState(() => _quantity++),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Add to Cart Button
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: Text(
                        'Pesan • ${AppTheme.formatRupiah(_calculatedTotalPrice)}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        final state = CanteenScope.of(context);
                        final cartItem = CartItem(
                          id: 'ci_${DateTime.now().millisecondsSinceEpoch}',
                          item: widget.item,
                          quantity: _quantity,
                          spicyLevel: _spicyLevel.round(),
                          portion: _selectedPortion,
                          selectedToppings: _selectedToppings.toList(),
                          notes: _notesController.text.trim(),
                        );
                        state.addToCart(cartItem);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle_rounded, color: Colors.white),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text('${widget.item.name} berhasil ditambahkan ke keranjang!'),
                                ),
                              ],
                            ),
                            backgroundColor: AppTheme.secondaryGreen,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
