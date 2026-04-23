import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ecommerce/screens/product_detail_screen.dart';
import 'package:flutter_ecommerce/providers/products_provider.dart';
import 'package:flutter_ecommerce/models/product.dart';

import '../helpers/test_helpers.dart';

void main() {
  const testProducts = [
    Product(
      id: '1',
      name: 'Test Headphones',
      description: 'Premium noise-cancelling headphones.',
      price: 149.99,
      imageUrl: 'url',
      category: 'Electronics',
      rating: 4.5,
      reviewCount: 1240,
    ),
  ];

  group('ProductDetailScreen', () {
    testWidgets('renders product name in app bar', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const ProductDetailScreen(productId: '1'),
          overrides: [
            productsProvider.overrideWith((ref) => testProducts),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Name appears both in AppBar title and in the body
      expect(find.text('Test Headphones'), findsWidgets);
    });

    testWidgets('displays product price', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const ProductDetailScreen(productId: '1'),
          overrides: [
            productsProvider.overrideWith((ref) => testProducts),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('\$149.99'), findsOneWidget);
    });

    testWidgets('displays product description', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const ProductDetailScreen(productId: '1'),
          overrides: [
            productsProvider.overrideWith((ref) => testProducts),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Premium noise-cancelling headphones.'),
        findsOneWidget,
      );
    });

    testWidgets('displays rating and review count', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const ProductDetailScreen(productId: '1'),
          overrides: [
            productsProvider.overrideWith((ref) => testProducts),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('(1240 reviews)'), findsOneWidget);
    });

    testWidgets('displays category chip', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const ProductDetailScreen(productId: '1'),
          overrides: [
            productsProvider.overrideWith((ref) => testProducts),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Electronics'), findsOneWidget);
      expect(find.byType(Chip), findsOneWidget);
    });

    testWidgets('shows Add to Cart button', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const ProductDetailScreen(productId: '1'),
          overrides: [
            productsProvider.overrideWith((ref) => testProducts),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Add to Cart'), findsOneWidget);
      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
    });

    testWidgets('tapping Add to Cart shows snackbar', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const ProductDetailScreen(productId: '1'),
          overrides: [
            productsProvider.overrideWith((ref) => testProducts),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add to Cart'));
      await tester.pump(); // trigger snackbar animation

      expect(
        find.text('Test Headphones added to cart'),
        findsOneWidget,
      );
    });

    testWidgets('shows not found for invalid product id', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const ProductDetailScreen(productId: '999'),
          overrides: [
            productsProvider.overrideWith((ref) => testProducts),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Product not found'), findsOneWidget);
    });

    testWidgets('not found screen has Product title in app bar', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const ProductDetailScreen(productId: '999'),
          overrides: [
            productsProvider.overrideWith((ref) => testProducts),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Product'), findsOneWidget);
    });
  });
}
