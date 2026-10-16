import 'package:flutter/material.dart';
import '../state/canteen_state.dart';
import '../models/order_model.dart';
import '../theme/app_theme.dart';
import 'receipt_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  final Function(int) onTabChange;

  const OrderHistoryScreen({super.key, required this.onTabChange});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showRatingDialog(BuildContext context, CanteenState state, OrderModel order) {
    double currentRating = order.reviewRating ?? 5.0;
    final commentController = TextEditingController(text: order.reviewComment ?? '');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Beri Ulasan ke Bu Sari', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bagaimana cita rasa makanan pada pesanan ${order.orderNumber}?',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 14),
              // Interactive Star Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starVal = index + 1.0;
                  return IconButton(
                    icon: Icon(
                      starVal <= currentRating ? Icons.star_rounded : Icons.star_border_rounded,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () {
                      setDialogState(() => currentRating = starVal);
                    },
                  );
                }),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: commentController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Tulis komentar atau masukan rasa...',
                  hintStyle: TextStyle(fontSize: 12),
                  prefixIcon: Icon(Icons.rate_review_outlined),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Nanti Saja')),
            ElevatedButton(
              onPressed: () {
                state.rateOrder(order.id, currentRating, commentController.text.trim());
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Terima kasih! Ulasan Anda telah terkirim ke Bu Sari.'),
                    backgroundColor: AppTheme.secondaryGreen,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Kirim Ulasan'),
            ),
          ],
        ),
      ),
    );
  }

  int _getStepIndex(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.cooking:
        return 1;
      case OrderStatus.ready:
        return 2;
      case OrderStatus.completed:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = CanteenScope.of(context);
    final theme = Theme.of(context);

    final activeOrders = state.orders.where((o) => o.status != OrderStatus.completed).toList();
    final completedOrders = state.orders.where((o) => o.status == OrderStatus.completed).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status & Riwayat Pesanan'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryOrange,
          labelColor: AppTheme.primaryOrange,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Pesanan Aktif'),
                  if (activeOrders.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryOrange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${activeOrders.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(text: 'Selesai (${completedOrders.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Pesanan Aktif
          activeOrders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant_rounded, size: 70, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      const Text(
                        'Tidak Ada Pesanan Aktif',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Semua pesanan Anda sudah selesai dinikmati.',
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => widget.onTabChange(1),
                        child: const Text('Pesan Makanan Sekarang'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: activeOrders.length,
                  itemBuilder: (context, index) {
                    final order = activeOrders[index];
                    final stepIdx = _getStepIndex(order.status);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header: Order ID & Status Badge
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.receipt_rounded, color: AppTheme.primaryOrange, size: 20),
                                    const SizedBox(width: 6),
                                    Text(
                                      order.orderNumber,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryOrange.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    order.status.label,
                                    style: const TextStyle(
                                      color: AppTheme.primaryOrange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${order.diningType} • ${order.tableNumber}',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                            const Divider(height: 20),

                            // Interactive Timeline / Stepper indicator
                            Row(
                              children: [
                                _buildStatusDot(
                                  isActive: stepIdx >= 0,
                                  isCurrent: stepIdx == 0,
                                  label: 'Diterima',
                                  icon: Icons.check,
                                ),
                                _buildStatusLine(isActive: stepIdx >= 1),
                                _buildStatusDot(
                                  isActive: stepIdx >= 1,
                                  isCurrent: stepIdx == 1,
                                  label: 'Dimasak',
                                  icon: Icons.soup_kitchen,
                                ),
                                _buildStatusLine(isActive: stepIdx >= 2),
                                _buildStatusDot(
                                  isActive: stepIdx >= 2,
                                  isCurrent: stepIdx == 2,
                                  label: 'Siap',
                                  icon: Icons.dining,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // ExpansionTile for Menu Details
                            Theme(
                              data: theme.copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.zero,
                                title: Text(
                                  '${order.items.length} Menu Dipesan • Total ${AppTheme.formatRupiah(order.totalAmount)}',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                children: order.items.map((it) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${it.quantity}x ${it.item.name}', style: const TextStyle(fontSize: 12)),
                                        Text(AppTheme.formatRupiah(it.totalPrice), style: const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Actions
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: const Icon(Icons.receipt_outlined, size: 16),
                                    label: const Text('Struk Digital', style: TextStyle(fontSize: 12)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => ReceiptScreen(order: order)),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.fast_forward_rounded, size: 16),
                                    label: const Text('Simulasi Dapur', style: TextStyle(fontSize: 12)),
                                    onPressed: () {
                                      state.advanceOrderStatus(order.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Status pesanan ${order.orderNumber} dimajukan!'),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

          // Tab 2: Riwayat Selesai
          completedOrders.isEmpty
              ? Center(
                  child: Text('Belum ada riwayat pesanan selesai.', style: TextStyle(color: Colors.grey[500])),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: completedOrders.length,
                  itemBuilder: (context, index) {
                    final order = completedOrders[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 14),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order.orderNumber,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppTheme.secondaryGreen.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Selesai',
                                    style: TextStyle(
                                      color: AppTheme.secondaryGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${order.orderTime.day}/${order.orderTime.month}/${order.orderTime.year} • ${order.paymentMethod}',
                              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                            ),
                            const Divider(height: 16),
                            ...order.items.map((it) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${it.quantity}x ${it.item.name}', style: const TextStyle(fontSize: 13)),
                                    Text(AppTheme.formatRupiah(it.totalPrice), style: const TextStyle(fontSize: 13)),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Biaya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                Text(
                                  AppTheme.formatRupiah(order.totalAmount),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primaryOrange),
                                ),
                              ],
                            ),
                            const Divider(height: 16),

                            // Rating & Actions
                            Row(
                              children: [
                                if (order.reviewRating != null) ...[
                                  const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${order.reviewRating!.toStringAsFixed(1)} / 5.0',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ] else
                                  OutlinedButton.icon(
                                    icon: const Icon(Icons.star_outline_rounded, size: 16),
                                    label: const Text('Beri Ulasan', style: TextStyle(fontSize: 11)),
                                    onPressed: () => _showRatingDialog(context, state, order),
                                  ),
                                const Spacer(),
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.receipt_outlined, size: 16),
                                  label: const Text('Struk', style: TextStyle(fontSize: 11)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => ReceiptScreen(order: order)),
                                    );
                                  },
                                ),
                                const SizedBox(width: 6),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.replay_rounded, size: 16),
                                  label: const Text('Pesan Lagi', style: TextStyle(fontSize: 11)),
                                  onPressed: () {
                                    for (final it in order.items) {
                                      state.addToCart(it);
                                    }
                                    widget.onTabChange(2); // Go to cart
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildStatusDot({
    required bool isActive,
    required bool isCurrent,
    required String label,
    required IconData icon,
  }) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primaryOrange : Colors.grey[300],
            shape: BoxShape.circle,
            border: isCurrent ? Border.all(color: AppTheme.primaryOrange, width: 3) : null,
          ),
          child: Icon(
            icon,
            size: 16,
            color: isActive ? Colors.white : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppTheme.primaryOrange : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusLine({required bool isActive}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        height: 3,
        color: isActive ? AppTheme.primaryOrange : Colors.grey[300],
      ),
    );
  }
}
