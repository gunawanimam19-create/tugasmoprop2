import 'cart_item.dart';

enum OrderStatus {
  pending('Menunggu Konfirmasi', 'Pesanan masuk ke dapur Bu Sari'),
  cooking('Sedang Dimasak', 'Bu Sari sedang menyiapkan pesanan Anda'),
  ready('Siap Diambil/Diantar', 'Makanan sudah matang & siap disajikan'),
  completed('Selesai', 'Pesanan telah selesai dinikmati');

  final String label;
  final String subtitle;
  const OrderStatus(this.label, this.subtitle);
}

class OrderModel {
  final String id;
  final String orderNumber;
  final List<CartItem> items;
  final int subtotal;
  final int discount;
  final int serviceFee;
  final int totalAmount;
  final String diningType; // 'Makan di Tempat (Dine In)' or 'Bungkus (Take Away)'
  final String tableNumber; // e.g. 'Meja 05' or '-'
  final String paymentMethod; // 'QRIS', 'Tunai / Kasir', 'Saldo Kantin'
  final DateTime orderTime;
  OrderStatus status;
  double? reviewRating;
  String? reviewComment;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.subtotal,
    this.discount = 0,
    this.serviceFee = 1000,
    required this.totalAmount,
    required this.diningType,
    required this.tableNumber,
    required this.paymentMethod,
    required this.orderTime,
    this.status = OrderStatus.pending,
    this.reviewRating,
    this.reviewComment,
  });
}
