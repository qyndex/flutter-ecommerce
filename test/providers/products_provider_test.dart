import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/providers/products_provider.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('productsProvider', () {
    test('returns 6 sample products', () {
      final products = container.read(productsProvider);
      expect(products.length, 6);
    });

    test('products have unique ids', () {
      final products = container.read(productsProvider);
      final ids = products.map((p) => p.id).toSet();
      expect(ids.length, products.length);
    });

    test('all products have positive prices', () {
      final products = container.read(productsProvider);
      for (final p in products) {
        expect(p.price, greaterThan(0));
      }
    });

    test('all products have ratings between 0 and 5', () {
      final products = container.read(productsProvider);
      for (final p in products) {
        expect(p.rating, greaterThanOrEqualTo(0));
        expect(p.rating, lessThanOrEqualTo(5));
      }
    });

    test('products span multiple categories', () {
      final products = container.read(productsProvider);
      final categories = products.map((p) => p.category).toSet();
      expect(categories.length, greaterThan(1));
    });
  });

  group('productByIdProvider', () {
    test('returns product for valid id', () {
      final product = container.read(productByIdProvider('1'));
      expect(product, isNotNull);
      expect(product!.id, '1');
      expect(product.name, 'Wireless Headphones');
    });

    test('returns null for non-existent id', () {
      final product = container.read(productByIdProvider('999'));
      expect(product, isNull);
    });

    test('returns correct product for each id', () {
      for (var i = 1; i <= 6; i++) {
        final product = container.read(productByIdProvider('$i'));
        expect(product, isNotNull);
        expect(product!.id, '$i');
      }
    });
  });
}
