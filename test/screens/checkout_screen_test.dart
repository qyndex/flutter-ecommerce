import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/screens/checkout_screen.dart';
import 'package:flutter_ecommerce/providers/cart_provider.dart';
import 'package:flutter_ecommerce/models/product.dart';

import '../helpers/test_helpers.dart';

void main() {
  const product = Product(
    id: '1',
    name: 'Test Item',
    description: 'desc',
    price: 50.00,
    imageUrl: 'url',
    category: 'cat',
    rating: 4.0,
    reviewCount: 10,
  );

  group('CheckoutScreen', () {
    testWidgets('renders Checkout title', (tester) async {
      await tester.pumpWidget(createTestApp(const CheckoutScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Checkout'), findsOneWidget);
    });

    testWidgets('renders shipping form fields', (tester) async {
      await tester.pumpWidget(createTestApp(const CheckoutScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Address'), findsOneWidget);
    });

    testWidgets('renders payment form field', (tester) async {
      await tester.pumpWidget(createTestApp(const CheckoutScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Card Number'), findsOneWidget);
    });

    testWidgets('renders section headers', (tester) async {
      await tester.pumpWidget(createTestApp(const CheckoutScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Shipping'), findsOneWidget);
      expect(find.text('Payment'), findsOneWidget);
    });

    testWidgets('renders Place Order button', (tester) async {
      await tester.pumpWidget(createTestApp(const CheckoutScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Place Order'), findsOneWidget);
    });

    testWidgets('shows total from cart', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const CheckoutScreen(),
          overrides: [
            cartProvider.overrideWith(() => _PreloadedCart([
                  CartItem(product: product, quantity: 2),
                ])),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('\$100.00'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
    });

    testWidgets('validates required Full Name field', (tester) async {
      await tester.pumpWidget(createTestApp(const CheckoutScreen()));
      await tester.pumpAndSettle();

      // Tap Place Order without filling in any fields
      await tester.tap(find.text('Place Order'));
      await tester.pumpAndSettle();

      expect(find.text('Required'), findsWidgets);
    });

    testWidgets('validates email format', (tester) async {
      await tester.pumpWidget(createTestApp(const CheckoutScreen()));
      await tester.pumpAndSettle();

      // Enter invalid email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'notanemail',
      );
      await tester.tap(find.text('Place Order'));
      await tester.pumpAndSettle();

      expect(find.text('Valid email required'), findsOneWidget);
    });

    testWidgets('validates card number length', (tester) async {
      await tester.pumpWidget(createTestApp(const CheckoutScreen()));
      await tester.pumpAndSettle();

      // Enter short card number
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Card Number'),
        '1234',
      );
      await tester.tap(find.text('Place Order'));
      await tester.pumpAndSettle();

      expect(find.text('Valid card required'), findsOneWidget);
    });

    testWidgets('successful order shows confirmation dialog', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const CheckoutScreen(),
          overrides: [
            cartProvider.overrideWith(() => _PreloadedCart([
                  CartItem(product: product, quantity: 1),
                ])),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Fill in all fields
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'John Doe',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'john@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Address'),
        '123 Main St',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Card Number'),
        '4111111111111111',
      );

      await tester.tap(find.text('Place Order'));
      // Wait for the 2-second simulated processing
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.text('Order Placed'), findsOneWidget);
      expect(find.text('Continue Shopping'), findsOneWidget);
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
