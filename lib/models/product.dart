class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final int stockCount;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.rating = 0,
    this.reviewCount = 0,
    this.stockCount = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: (json['description'] as String?) ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: (json['image_url'] as String?) ?? '',
      category: (json['category'] as String?) ?? '',
      rating: ((json['rating'] as num?) ?? 0).toDouble(),
      reviewCount: (json['review_count'] as int?) ?? 0,
      stockCount: (json['stock_count'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'category': category,
      'rating': rating,
      'review_count': reviewCount,
      'stock_count': stockCount,
    };
  }
}

class CartItem {
  final String id;
  final Product product;
  final int quantity;

  const CartItem({
    this.id = '',
    required this.product,
    required this.quantity,
  });

  CartItem copyWith({int? quantity}) =>
      CartItem(id: id, product: product, quantity: quantity ?? this.quantity);

  double get total => product.price * quantity;
}
