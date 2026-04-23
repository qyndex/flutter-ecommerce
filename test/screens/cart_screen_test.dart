import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/screens/cart_screen.dart';
import 'package:flutter_ecommerce/providers/cart_provider.dart';
import 'package:flutter_ecommerce/models/product.dart';

import '../helpers/test_helpers.dart';

void main() {
  const productA = Product(
    id: '1',
    name: 'Test Widget',
    description: 'desc',
    price: 25.00,
    imageUrl: 'url',
    category: 'cat',
    rating: 4.0,
    reviewCount: 10,
  );

  const productB = Product(
    id: '2',
    name: 'Another Widget',
    description: 'desc',
    price: 15.00,
    imageUrl: 'url',
    category: 'cat',
    rating: 3.5,
    reviewCount: 5,
  );

  group('CartScreen', () {
    testWidgets('shows empty state when cart is empty', (tester) async {
      await tester.pumpWidget(createTestApp(const CartScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });

    testWidgets('shows app bar with Cart title', (tester) async {
      await tester.pumpWidget(createTestApp(const CartScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Cart'), findsOneWidget);
    });

    testWidgets('displays cart items when populated', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const CartScreen(),
          overrides: [
            cartProvider.overrideWith(() => _PreloadedCart([
                  CartItem(product: productA, quantity: 2),
                  CartItem(product: productB, quantity: 1),
                ])),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Widget'), findsOneWidget);
      expect(find.text('Another Widget'), findsOneWidget);
    });

    testWidgets('displays product prices', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const CartScreen(),
          overrides: [
            cartProvider.overrideWith(() => _PreloadedCart([
                  CartItem(product: productA, quantity: 1),
                ])),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('\$25.00'), findsWidgets);
    });

    testWidgets('displays item quantity', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const CartScreen(),
          overrides: [
            cartProvider.overrideWith(() => _PreloadedCart([
                  CartItem(product: productA, quantity: 3),
                ])),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('shows subtotal', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const CartScreen(),
          overrides: [
            cartProvider.overrideWith(() => _PreloadedCart([
                  CartItem(product: productA, quantity: 2), // 50.00
                  CartItem(product: productB, quantity: 1), // 15.00
                ])),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('\$65.00'), findsOneWidget);
      expect(find.text('Subtotal'), findsOneWidget);
    });

    testWidgets('shows Proceed to Checkout button', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const CartScreen(),
          overrides: [
            cartProvider.overrideWith(() => _PreloadedCart([
                  CartItem(product: productA, quantity: 1),
                ])),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Proceed to Checkout'), findsOneWidget);
    });

    testWidgets('tapping checkout button navigates to checkout', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const CartScreen(),
          overrides: [
            cartProvider.overrideWith(() => _PreloadedCart([
                  CartItem(product: productA, quantity: 1),
                ])),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Proceed to Checkout'));
      await tester.pumpAndSettle();

      expect(find.text('Checkout Page'), findsOneWidget);
    });

    testWidgets('increment and decrement buttons present', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const CartScreen(),
          overrides: [
            cartProvider.overrideWith(() => _PreloadedCart([
                  CartItem(product: productA, quantity: 2),
                ])),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.remove_circle_outline), findsOneWidget);
    });
  });
}

/// A Cart notifier pre-loaded with items for testing.
class _PreloadedCart extends Cart {
  final List<CartItem> _initial;
  _PreloadedCart(this._initial);

  @override
  List<CartItem> build() => _initial;
}
