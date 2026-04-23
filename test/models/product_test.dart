import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/models/product.dart';

void main() {
  group('Product', () {
    test('constructor sets all fields', () {
      const product = Product(
        id: '1',
        name: 'Test Product',
        description: 'A description',
        price: 29.99,
        imageUrl: 'https://example.com/img.png',
        category: 'Electronics',
        rating: 4.5,
        reviewCount: 100,
      );

      expect(product.id, '1');
      expect(product.name, 'Test Product');
      expect(product.description, 'A description');
      expect(product.price, 29.99);
      expect(product.imageUrl, 'https://example.com/img.png');
      expect(product.category, 'Electronics');
      expect(product.rating, 4.5);
      expect(product.reviewCount, 100);
    });

    test('const constructor allows compile-time constants', () {
      // Verifies const-constructible requirement from CLAUDE.md
      const product = Product(
        id: '1',
        name: 'Const Product',
        description: 'desc',
        price: 10.0,
        imageUrl: 'url',
        category: 'cat',
        rating: 3.0,
        reviewCount: 0,
      );
      expect(product.name, 'Const Product');
    });
  });

  group('CartItem', () {
    const product = Product(
      id: '1',
      name: 'Widget',
      description: 'desc',
      price: 25.0,
      imageUrl: 'url',
      category: 'cat',
      rating: 4.0,
      reviewCount: 50,
    );

    test('total multiplies price by quantity', () {
      const item = CartItem(product: product, quantity: 3);
      expect(item.total, 75.0);
    });

    test('total is zero when quantity is zero', () {
      const item = CartItem(product: product, quantity: 0);
      expect(item.total, 0.0);
    });

    test('total handles single quantity', () {
      const item = CartItem(product: product, quantity: 1);
      expect(item.total, 25.0);
    });

    test('copyWith updates quantity', () {
      const item = CartItem(product: product, quantity: 1);
      final updated = item.copyWith(quantity: 5);
      expect(updated.quantity, 5);
      expect(updated.product.id, '1');
    });

    test('copyWith preserves quantity when null', () {
      const item = CartItem(product: product, quantity: 3);
      final updated = item.copyWith();
      expect(updated.quantity, 3);
    });

    test('copyWith preserves product reference', () {
      const item = CartItem(product: product, quantity: 1);
      final updated = item.copyWith(quantity: 10);
      expect(identical(updated.product, product), isTrue);
    });
  });
}
