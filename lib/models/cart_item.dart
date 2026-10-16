import 'menu_item.dart';

class CartItem {
  final String id;
  final MenuItem item;
  int quantity;
  final int spicyLevel; // 0 - 5
  final String portion; // 'Reguler', 'Jumbo'
  final List<ToppingOption> selectedToppings;
  final String notes;

  CartItem({
    required this.id,
    required this.item,
    this.quantity = 1,
    this.spicyLevel = 1,
    this.portion = 'Reguler',
    this.selectedToppings = const [],
    this.notes = '',
  });

  int get itemUnitPrice {
    int base = item.discountedPrice;
    if (portion == 'Jumbo') {
      base += 4000;
    }
    int toppingTotal = selectedToppings.fold(0, (sum, top) => sum + top.price);
    return base + toppingTotal;
  }

  int get totalPrice => itemUnitPrice * quantity;

  CartItem copyWith({
    int? quantity,
    int? spicyLevel,
    String? portion,
    List<ToppingOption>? selectedToppings,
    String? notes,
  }) {
    return CartItem(
      id: id,
      item: item,
      quantity: quantity ?? this.quantity,
      spicyLevel: spicyLevel ?? this.spicyLevel,
      portion: portion ?? this.portion,
      selectedToppings: selectedToppings ?? this.selectedToppings,
      notes: notes ?? this.notes,
    );
  }
}
