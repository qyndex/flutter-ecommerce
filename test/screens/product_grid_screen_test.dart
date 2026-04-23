import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/screens/product_grid_screen.dart';
import 'package:flutter_ecommerce/providers/products_provider.dart';
import 'package:flutter_ecommerce/models/product.dart';

import '../helpers/test_helpers.dart';

void main() {
  const testProducts = [
    Product(
      id: '1',
      name: 'Test Headphones',
      description: 'desc',
      price: 49.99,
      imageUrl: 'url',
      category: 'Electronics',
      rating: 4.2,
      reviewCount: 100,
    ),
    Product(
      id: '2',
      name: 'Test Shoes',
      description: 'desc',
      price: 79.99,
      imageUrl: 'url',
      category: 'Sports',
      rating: 4.0,
      reviewCount: 50,
    ),
  ];

  group('ProductGridScreen', () {
    testWidgets('renders app bar with Shop title', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const ProductGridScreen(),
          overrides: [
            productsProvider.overrideWith((ref) => testProducts),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Shop'), findsOneWidget);
    });

    testWidgets('displays product names', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const ProductGridScreen(),
          overrides: [
            productsProvider.overrideWith((ref) => testProducts),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Headphones'), findsOneWidget);
      expect(find.text('Test Shoes'), findsOneWidget);
    });

    testWidgets('displays product prices', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const ProductGridScreen(),
          overrides: [
            productsProvider.overrideWith((ref) => testProducts),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('\$49.99'), findsOneWidget);
      expect(find.text('\$79.99'), findsOneWidget);
    });

    testWidgets('displays product ratings', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const ProductGridScreen(),
          overrides: [
            productsProvider.overrideWith((ref) => testProducts),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('4.2'), findsOneWidget);
      expect(find.text('4.0'), findsOneWidget);
    });

    testWidgets('shows cart icon in app bar', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const ProductGridScreen(),
          overrides: [
            productsProvider.overrideWith((ref) => testProducts),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });

    testWidgets('renders grid with correct item count', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const ProductGridScreen(),
          overrides: [
            productsProvider.overrideWith((ref) => testProducts),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Each product renders as a Card
      expect(find.byType(Card), findsNWidgets(2));
    });

    testWidgets('tapping cart icon navigates to cart', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const ProductGridScreen(),
          overrides: [
            productsProvider.overrideWith((ref) => testProducts),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Cart Page'), findsOneWidget);
    });

    testWidgets('tapping product card navigates to detail', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const ProductGridScreen(),
          overrides: [
            productsProvider.overrideWith((ref) => testProducts),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Test Headphones'));
      await tester.pumpAndSettle();

      expect(find.text('Product 1'), findsOneWidget);
    });

    testWidgets('empty product list shows no cards', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const ProductGridScreen(),
          overrides: [
            productsProvider.overrideWith((ref) => <Product>[]),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsNothing);
    });
  });
}
