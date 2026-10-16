import 'package:flutter/material.dart';
import '../state/canteen_state.dart';
import '../theme/app_theme.dart';
import 'receipt_screen.dart';

class CartScreen extends StatefulWidget {
  final Function(int) onTabChange;

  const CartScreen({super.key, required this.onTabChange});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _diningType = 'Makan di Tempat (Dine In)';
  String _selectedTable = 'Meja 05';
  String _paymentMethod = 'Saldo Kantin';
  final TextEditingController _voucherController = TextEditingController();

  final List<String> _tableList = [
    'Meja 01',
    'Meja 02',
    'Meja 03',
    'Meja 04',
    'Meja 05',
    'Meja 06',
    'Meja 07',
    'Meja 08',
    'Meja 09',
    'Meja 10',
    'Meja 12 (Outdoor)',
    'Meja 15 (Lantai 2)',
  ];

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  void _processCheckout(BuildContext context, CanteenState state) {
    if (state.cartItems.isEmpty) return;

    if (_paymentMethod == 'Saldo Kantin' && state.walletBalance < state.cartTotal) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Text('Saldo Tidak Cukup'),
            ],
          ),
          content: Text(
            'Saldo Kantin Pay Anda (${AppTheme.formatRupiah(state.walletBalance)}) tidak mencukupi untuk total pesanan (${AppTheme.formatRupiah(state.cartTotal)}). Silakan pilih metode lain atau lakukan Top Up.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tutup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => _paymentMethod = 'QRIS');
              },
              child: const Text('Ganti ke QRIS'),
            ),
          ],
        ),
      );
      return;
    }

    final newOrder = state.placeOrder(
      diningType: _diningType,
      tableNumber: _diningType.contains('Dine In') ? _selectedTable : '-',
      paymentMethod: _paymentMethod,
    );

    if (newOrder != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppTheme.secondaryGreen, size: 54),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pesanan Berhasil Dibuat!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'No. Antrean: ${newOrder.orderNumber}\nBu Sari segera menyiapkan hidangan Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ReceiptScreen(order: newOrder)),
                        );
                      },
                      child: const Text('Lihat Struk', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        widget.onTabChange(3); // Go to Order History tab
                      },
                      child: const Text('Pantau Status', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = CanteenScope.of(context);

    if (state.cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Keranjang Belanja')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shopping_cart_outlined, size: 72, color: AppTheme.primaryOrange),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Keranjang Belanja Masih Kosong',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pilih aneka makanan dan minuman lezat dari Bu Sari untuk mengisi keranjang Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.restaurant_menu_rounded),
                  label: const Text('Eksplorasi Menu Sekarang'),
                  onPressed: () => widget.onTabChange(1), // Go to catalog
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang & Checkout'),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Kosongkan Keranjang?'),
                  content: const Text('Semua menu yang telah dipilih akan dihapus.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentRed),
                      onPressed: () {
                        state.clearCart();
                        Navigator.pop(ctx);
                      },
                      child: const Text('Kosongkan'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Kosongkan', style: TextStyle(color: AppTheme.accentRed, fontSize: 13)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List of Cart Items with Dismissible
            const Text(
              'Rincian Menu Dipesan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Geser item ke kiri untuk menghapus',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
            const SizedBox(height: 10),

            ...state.cartItems.map((cartItem) {
              return Dismissible(
                key: Key(cartItem.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentRed,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 28),
                ),
                onDismissed: (_) {
                  state.removeFromCart(cartItem.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${cartItem.item.name} dihapus dari keranjang'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            cartItem.item.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 60,
                              height: 60,
                              color: Colors.orange.withOpacity(0.2),
                              child: const Icon(Icons.fastfood, color: AppTheme.primaryOrange),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartItem.item.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                [
                                  if (cartItem.portion == 'Jumbo') 'Jumbo',
                                  if (cartItem.item.spicyLevelAvailable) 'Pedas Lvl ${cartItem.spicyLevel}',
                                  ...cartItem.selectedToppings.map((t) => t.name),
                                ].join(', '),
                                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                              ),
                              if (cartItem.notes.isNotEmpty)
                                Text(
                                  'Catatan: ${cartItem.notes}',
                                  style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey[500]),
                                ),
                              const SizedBox(height: 6),
                              Text(
                                AppTheme.formatRupiah(cartItem.totalPrice),
                                style: const TextStyle(
                                  color: AppTheme.primaryOrange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Stepper (- Qty +)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => state.updateCartQuantity(cartItem.id, -1),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(Icons.remove, size: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '${cartItem.quantity}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),
                              InkWell(
                                onTap: () => state.updateCartQuantity(cartItem.id, 1),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(Icons.add, size: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),
            const Divider(),

            // Dining Type Segmented Button
            const Text(
              'Opsi Penyajian',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'Makan di Tempat (Dine In)',
                    label: Text('Makan di Tempat'),
                    icon: Icon(Icons.restaurant),
                  ),
                  ButtonSegment(
                    value: 'Bungkus (Take Away)',
                    label: Text('Bungkus Pulang'),
                    icon: Icon(Icons.shopping_bag),
                  ),
                ],
                selected: {_diningType},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() => _diningType = newSelection.first);
                },
              ),
            ),
            const SizedBox(height: 12),

            // Table Number Dropdown (only if Dine In)
            if (_diningType.contains('Dine In')) ...[
              DropdownButtonFormField<String>(
                value: _selectedTable,
                decoration: const InputDecoration(
                  labelText: 'Nomor Meja Pelanggan',
                  prefixIcon: Icon(Icons.table_restaurant_rounded, color: AppTheme.primaryOrange),
                ),
                items: _tableList.map((tbl) {
                  return DropdownMenuItem<String>(
                    value: tbl,
                    child: Text(tbl),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedTable = val);
                },
              ),
              const SizedBox(height: 12),
            ],

            // Cutlery SwitchListTile
            Card(
              child: SwitchListTile(
                value: state.includeCutlery,
                activeColor: AppTheme.primaryOrange,
                title: const Text('Sertakan Alat Makan Ramah Lingkungan', style: TextStyle(fontSize: 13)),
                subtitle: const Text('Sendok & tisu gratis untuk kenyamanan makan Anda', style: TextStyle(fontSize: 11)),
                secondary: const Icon(Icons.flatware_rounded, color: AppTheme.primaryOrange),
                onChanged: (val) => state.toggleCutlery(val),
              ),
            ),
            const SizedBox(height: 16),

            // Voucher Promo Code Input
            const Text(
              'Voucher Diskon Mahasiswa',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _voucherController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Coba: DISKONMHS atau BUSARIHEMAT',
                      hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      prefixIcon: const Icon(Icons.confirmation_number_outlined),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final res = state.applyVoucher(_voucherController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(res),
                        backgroundColor: res.startsWith('Berhasil') ? AppTheme.secondaryGreen : AppTheme.accentRed,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('Terapkan'),
                ),
              ],
            ),
            if (state.appliedPromoCode != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppTheme.secondaryGreen, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Kupon "${state.appliedPromoCode}" aktif: Diskon ${AppTheme.formatRupiah(state.voucherDiscount)}',
                      style: const TextStyle(color: AppTheme.secondaryGreen, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                      onPressed: () => state.removeVoucher(),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),
            const Divider(),

            // Payment Methods (Radio Cards)
            const Text(
              'Metode Pembayaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  RadioListTile<String>(
                    value: 'Saldo Kantin',
                    groupValue: _paymentMethod,
                    title: Row(
                      children: [
                        const Text('Saldo Kantin Pay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const Spacer(),
                        Text(
                          AppTheme.formatRupiah(state.walletBalance),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: state.walletBalance >= state.cartTotal ? AppTheme.secondaryGreen : AppTheme.accentRed,
                          ),
                        ),
                      ],
                    ),
                    subtitle: const Text('Pembayaran instan bebas biaya & raih poin', style: TextStyle(fontSize: 11)),
                    secondary: const Icon(Icons.account_balance_wallet_rounded, color: AppTheme.primaryOrange),
                    activeColor: AppTheme.primaryOrange,
                    onChanged: (val) {
                      if (val != null) setState(() => _paymentMethod = val);
                    },
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    value: 'QRIS',
                    groupValue: _paymentMethod,
                    title: const Text('QRIS (BCA, GoPay, OVO, Dana)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: const Text('Scan QR code yang tertera di kasir kantin', style: TextStyle(fontSize: 11)),
                    secondary: const Icon(Icons.qr_code_2_rounded, color: Colors.blue),
                    activeColor: AppTheme.primaryOrange,
                    onChanged: (val) {
                      if (val != null) setState(() => _paymentMethod = val);
                    },
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    value: 'Tunai / Kasir',
                    groupValue: _paymentMethod,
                    title: const Text('Tunai / Bayar di Kasir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: const Text('Bayar langsung dengan uang pas saat mengambil pesanan', style: TextStyle(fontSize: 11)),
                    secondary: const Icon(Icons.payments_rounded, color: Colors.green),
                    activeColor: AppTheme.primaryOrange,
                    onChanged: (val) {
                      if (val != null) setState(() => _paymentMethod = val);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(),

            // Summary Breakdown
            const Text(
              'Ringkasan Biaya',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSummaryRow('Subtotal Pesanan', AppTheme.formatRupiah(state.cartSubtotal)),
                    if (state.voucherDiscount > 0)
                      _buildSummaryRow(
                        'Diskon Voucher',
                        '-${AppTheme.formatRupiah(state.voucherDiscount)}',
                        textColor: AppTheme.accentRed,
                      ),
                    _buildSummaryRow('Biaya Layanan & Pengemasan', AppTheme.formatRupiah(state.serviceFee)),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                          AppTheme.formatRupiah(state.cartTotal),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Checkout Action Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.lock_outline),
                label: Text(
                  'Konfirmasi & Pesan (${AppTheme.formatRupiah(state.cartTotal)})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () => _processCheckout(context, state),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
