import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/cart_item.dart';
import '../models/order_model.dart';
import '../data/mock_data.dart';

class CanteenState extends ChangeNotifier {
  List<MenuItem> _menuItems = [];
  final List<CartItem> _cartItems = [];
  List<OrderModel> _orders = [];

  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  String _selectedSort = 'Terpopuler';

  int _walletBalance = 85000;
  final String _userName = 'Imam Mahasiswa';
  final String _userNim = '2201010045';
  int _userPoints = 350;
  bool _isDarkMode = false;
  bool _includeCutlery = true;

  String? _appliedPromoCode;
  int _voucherDiscount = 0;

  CanteenState() {
    _menuItems = List.from(MockData.menuItems);
    _orders = MockData.getInitialOrders();
  }

  // Getters
  List<MenuItem> get menuItems => _menuItems;
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  List<OrderModel> get orders => List.unmodifiable(_orders);

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get selectedSort => _selectedSort;

  int get walletBalance => _walletBalance;
  String get userName => _userName;
  String get userNim => _userNim;
  int get userPoints => _userPoints;
  bool get isDarkMode => _isDarkMode;
  bool get includeCutlery => _includeCutlery;
  String? get appliedPromoCode => _appliedPromoCode;
  int get voucherDiscount => _voucherDiscount;

  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  int get cartSubtotal => _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  int get serviceFee => _cartItems.isEmpty ? 0 : 1000;

  int get cartTotal {
    if (_cartItems.isEmpty) return 0;
    int total = cartSubtotal + serviceFee - _voucherDiscount;
    return total < 0 ? 0 : total;
  }

  List<MenuItem> get filteredMenuItems {
    List<MenuItem> list = _menuItems.where((item) {
      final matchesCategory = _selectedCategory == 'Semua' || item.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();

    if (_selectedSort == 'Harga Terendah') {
      list.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
    } else if (_selectedSort == 'Harga Tertinggi') {
      list.sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
    } else if (_selectedSort == 'Rating Tertinggi') {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    } else {
      // Default: Terpopuler
      list.sort((a, b) {
        if (a.isPopular && !b.isPopular) return -1;
        if (!a.isPopular && b.isPopular) return 1;
        return b.reviewCount.compareTo(a.reviewCount);
      });
    }

    return list;
  }

  // Actions
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSort(String sort) {
    _selectedSort = sort;
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void toggleCutlery(bool value) {
    _includeCutlery = value;
    notifyListeners();
  }

  void addToCart(CartItem item) {
    // Check if duplicate item with same options exists
    final index = _cartItems.indexWhere((ci) =>
        ci.item.id == item.item.id &&
        ci.spicyLevel == item.spicyLevel &&
        ci.portion == item.portion &&
        _areToppingsEqual(ci.selectedToppings, item.selectedToppings) &&
        ci.notes.trim() == item.notes.trim());

    if (index != -1) {
      _cartItems[index].quantity += item.quantity;
    } else {
      _cartItems.add(item);
    }
    _recalculateVoucher();
    notifyListeners();
  }

  bool _areToppingsEqual(List<ToppingOption> a, List<ToppingOption> b) {
    if (a.length != b.length) return false;
    final aIds = a.map((e) => e.id).toSet();
    final bIds = b.map((e) => e.id).toSet();
    return aIds.containsAll(bIds);
  }

  void updateCartQuantity(String cartItemId, int delta) {
    final index = _cartItems.indexWhere((ci) => ci.id == cartItemId);
    if (index != -1) {
      _cartItems[index].quantity += delta;
      if (_cartItems[index].quantity <= 0) {
        _cartItems.removeAt(index);
      }
      _recalculateVoucher();
      notifyListeners();
    }
  }

  void removeFromCart(String cartItemId) {
    _cartItems.removeWhere((ci) => ci.id == cartItemId);
    _recalculateVoucher();
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _appliedPromoCode = null;
    _voucherDiscount = 0;
    notifyListeners();
  }

  String applyVoucher(String code) {
    final clean = code.trim().toUpperCase();
    if (_cartItems.isEmpty) {
      return 'Keranjang masih kosong!';
    }
    if (clean == 'DISKONMHS') {
      _appliedPromoCode = 'DISKONMHS';
      _voucherDiscount = (cartSubtotal * 0.15).round(); // 15% diskon
      notifyListeners();
      return 'Berhasil! Voucher diskon 15% mahasiswa aktif.';
    } else if (clean == 'BUSARIHEMAT') {
      _appliedPromoCode = 'BUSARIHEMAT';
      _voucherDiscount = 5000;
      notifyListeners();
      return 'Berhasil! Potongan langsung Rp 5.000.';
    } else {
      return 'Kode promo tidak valid atau sudah kedaluwarsa.';
    }
  }

  void removeVoucher() {
    _appliedPromoCode = null;
    _voucherDiscount = 0;
    notifyListeners();
  }

  void _recalculateVoucher() {
    if (_cartItems.isEmpty) {
      _appliedPromoCode = null;
      _voucherDiscount = 0;
      return;
    }
    if (_appliedPromoCode == 'DISKONMHS') {
      _voucherDiscount = (cartSubtotal * 0.15).round();
    } else if (_appliedPromoCode == 'BUSARIHEMAT') {
      _voucherDiscount = 5000 > cartSubtotal ? cartSubtotal : 5000;
    }
  }

  OrderModel? placeOrder({
    required String diningType,
    required String tableNumber,
    required String paymentMethod,
  }) {
    if (_cartItems.isEmpty) return null;

    final total = cartTotal;

    // Check balance if paying with Saldo Kantin
    if (paymentMethod == 'Saldo Kantin') {
      if (_walletBalance < total) {
        return null;
      }
      _walletBalance -= total;
    }

    final newOrder = OrderModel(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      orderNumber: 'KBS-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      items: List.from(_cartItems),
      subtotal: cartSubtotal,
      discount: _voucherDiscount,
      serviceFee: serviceFee,
      totalAmount: total,
      diningType: diningType,
      tableNumber: tableNumber,
      paymentMethod: paymentMethod,
      orderTime: DateTime.now(),
      status: OrderStatus.pending,
    );

    _orders.insert(0, newOrder);
    _userPoints += (total / 1000).round(); // 1 point per Rp 1.000
    clearCart();
    notifyListeners();
    return newOrder;
  }

  void advanceOrderStatus(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final current = _orders[index].status;
      if (current == OrderStatus.pending) {
        _orders[index].status = OrderStatus.cooking;
      } else if (current == OrderStatus.cooking) {
        _orders[index].status = OrderStatus.ready;
      } else if (current == OrderStatus.ready) {
        _orders[index].status = OrderStatus.completed;
      }
      notifyListeners();
    }
  }

  void rateOrder(String orderId, double rating, String comment) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].reviewRating = rating;
      _orders[index].reviewComment = comment;
      notifyListeners();
    }
  }

  void topUpWallet(int amount) {
    _walletBalance += amount;
    notifyListeners();
  }
}

class CanteenScope extends InheritedNotifier<CanteenState> {
  const CanteenScope({
    super.key,
    required CanteenState state,
    required super.child,
  }) : super(notifier: state);

  static CanteenState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CanteenScope>();
    assert(scope != null, 'CanteenScope not found in context');
    return scope!.notifier!;
  }
}
