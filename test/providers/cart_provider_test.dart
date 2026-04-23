import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/providers/cart_provider.dart';

void main() {
  const productA = Product(
    id: '1',
    name: 'Product A',
    description: 'desc',
    price: 10.0,
    imageUrl: 'url',
    category: 'cat',
    rating: 4.0,
    reviewCount: 10,
  );

  const productB = Product(
    id: '2',
    name: 'Product B',
    description: 'desc',
    price: 20.0,
    imageUrl: 'url',
    category: 'cat',
    rating: 3.5,
    reviewCount: 5,
  );

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('Cart', () {
    test('starts empty', () {
      final items = container.read(cartProvider);
      expect(items, isEmpty);
    });

    test('addItem adds a new product with quantity 1', () {
      container.read(cartProvider.notifier).addItem(productA);
      final items = container.read(cartProvider);
      expect(items.length, 1);
      expect(items.first.product.id, '1');
      expect(items.first.quantity, 1);
    });

    test('addItem increments quantity for duplicate product', () {
      final cart = container.read(cartProvider.notifier);
      cart.addItem(productA);
      cart.addItem(productA);
      final items = container.read(cartProvider);
      expect(items.length, 1);
      expect(items.first.quantity, 2);
    });

    test('addItem keeps separate entries for different products', () {
      final cart = container.read(cartProvider.notifier);
      cart.addItem(productA);
      cart.addItem(productB);
      final items = container.read(cartProvider);
      expect(items.length, 2);
    });

    test('removeItem removes the correct product', () {
      final cart = container.read(cartProvider.notifier);
      cart.addItem(productA);
      cart.addItem(productB);
      cart.removeItem('1');
      final items = container.read(cartProvider);
      expect(items.length, 1);
      expect(items.first.product.id, '2');
    });

    test('removeItem is no-op for non-existent product', () {
      final cart = container.read(cartProvider.notifier);
      cart.addItem(productA);
      cart.removeItem('999');
      expect(container.read(cartProvider).length, 1);
    });

    test('updateQuantity changes quantity', () {
      final cart = container.read(cartProvider.notifier);
      cart.addItem(productA);
      cart.updateQuantity('1', 5);
      final items = container.read(cartProvider);
      expect(items.first.quantity, 5);
    });

    test('updateQuantity with zero removes item', () {
      final cart = container.read(cartProvider.notifier);
      cart.addItem(productA);
      cart.updateQuantity('1', 0);
      expect(container.read(cartProvider), isEmpty);
    });

    test('updateQuantity with negative removes item', () {
      final cart = container.read(cartProvider.notifier);
      cart.addItem(productA);
      cart.updateQuantity('1', -1);
      expect(container.read(cartProvider), isEmpty);
    });

    test('clear removes all items', () {
      final cart = container.read(cartProvider.notifier);
      cart.addItem(productA);
      cart.addItem(productB);
      cart.clear();
      expect(container.read(cartProvider), isEmpty);
    });

    test('subtotal sums all item totals', () {
      final cart = container.read(cartProvider.notifier);
      cart.addItem(productA); // 10.0
      cart.addItem(productB); // 20.0
      cart.addItem(productA); // 10.0 x2 = 20.0
      expect(cart.subtotal, 40.0); // 20.0 + 20.0
    });

    test('itemCount sums all quantities', () {
      final cart = container.read(cartProvider.notifier);
      cart.addItem(productA);
      cart.addItem(productA);
      cart.addItem(productB);
      expect(cart.itemCount, 3); // 2 + 1
    });

    test('subtotal is zero when cart is empty', () {
      final cart = container.read(cartProvider.notifier);
      expect(cart.subtotal, 0.0);
    });

    test('itemCount is zero when cart is empty', () {
      final cart = container.read(cartProvider.notifier);
      expect(cart.itemCount, 0);
    });
  });
}
