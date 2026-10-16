class ToppingOption {
  final String id;
  final String name;
  final int price;

  const ToppingOption({
    required this.id,
    required this.name,
    required this.price,
  });
}

class MenuItem {
  final String id;
  final String name;
  final String category; // 'Makanan Berat', 'Camilan / Snack', 'Minuman Segar', 'Paket Hemat'
  final int price;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final bool isPopular;
  final bool isPromo;
  final int discountPercent;
  final bool spicyLevelAvailable;
  final List<ToppingOption> availableToppings;

  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    this.rating = 4.8,
    this.reviewCount = 50,
    this.isPopular = false,
    this.isPromo = false,
    this.discountPercent = 0,
    this.spicyLevelAvailable = false,
    this.availableToppings = const [],
  });

  int get discountedPrice {
    if (isPromo && discountPercent > 0) {
      return (price * (100 - discountPercent) / 100).round();
    }
    return price;
  }
}
