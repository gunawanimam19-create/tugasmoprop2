import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../theme/app_theme.dart';

class ReceiptScreen extends StatelessWidget {
  final OrderModel order;

  const ReceiptScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bukti Pesanan Digital'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Bagikan Struk',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tautan struk digital disalin ke papan klip!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Receipt Container Paper
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  children: [
                    // Header Brand
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryOrange.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.receipt_long_rounded, color: AppTheme.primaryOrange, size: 36),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'KANTIN BU SARI',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                    ),
                    Text(
                      'Pujasera Kampus Lt. 1 • Stand No. 04',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryGreen.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'PEMBAYARAN LUNAS',
                        style: TextStyle(
                          color: AppTheme.secondaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(thickness: 1.2),

                    // Order Info
                    _buildReceiptRow('No. Pesanan', order.orderNumber, isBold: true),
                    _buildReceiptRow(
                      'Waktu',
                      '${order.orderTime.day}/${order.orderTime.month}/${order.orderTime.year} ${order.orderTime.hour.toString().padLeft(2, '0')}:${order.orderTime.minute.toString().padLeft(2, '0')} WIB',
                    ),
                    _buildReceiptRow('Tipe Pesanan', order.diningType),
                    if (order.tableNumber != '-')
                      _buildReceiptRow('Lokasi Meja', order.tableNumber, isBold: true),
                    _buildReceiptRow('Metode Bayar', order.paymentMethod),
                    const Divider(thickness: 1.2),
                    const SizedBox(height: 8),

                    // Items List
                    ...order.items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.quantity}x ${item.item.name}',
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                ),
                                Text(
                                  AppTheme.formatRupiah(item.totalPrice),
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                ),
                              ],
                            ),
                            if (item.portion == 'Jumbo' || item.spicyLevel > 0 || item.selectedToppings.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2, left: 18),
                                child: Text(
                                  [
                                    if (item.portion == 'Jumbo') 'Jumbo (+Rp 4.000)',
                                    if (item.item.spicyLevelAvailable) 'Level Pedas ${item.spicyLevel}',
                                    ...item.selectedToppings.map((t) => t.name),
                                  ].join(' • '),
                                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                                ),
                              ),
                            if (item.notes.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2, left: 18),
                                child: Text(
                                  'Catatan: "${item.notes}"',
                                  style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey[500]),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 10),
                    const Divider(thickness: 1.2),

                    // Calculations
                    _buildReceiptRow('Subtotal', AppTheme.formatRupiah(order.subtotal)),
                    if (order.discount > 0)
                      _buildReceiptRow(
                        'Diskon Kupon',
                        '-${AppTheme.formatRupiah(order.discount)}',
                        textColor: AppTheme.accentRed,
                      ),
                    _buildReceiptRow('Biaya Layanan', AppTheme.formatRupiah(order.serviceFee)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL BAYAR',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          AppTheme.formatRupiah(order.totalAmount),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Barcode / QR Simulation
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[850] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.qr_code_2_rounded, size: 48),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.orderNumber,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                'Tunjukkan ke kasir saat mengambil pesanan',
                                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Simpan Struk'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Struk berhasil disimpan dalam format PDF/Gambar!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Selesai'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: textColor ?? Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
