class WishlistItem {
  final int id;
  final int userId;
  final int productId;
  final Product product;

  WishlistItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.product,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      product: Product.fromJson(json['product'] ?? {}),
    );
  }
}

class Product {
  final int id;
  final String title;
  final double price; // <—— FIX: Use double
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown Product',
      price:
          double.tryParse(json['price']?.toString() ?? '0') ?? 0.0, // <—— SAFE
      imageUrl: json['image_url'] ?? '',
    );
  }
}
