import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Wraps a widget in MaterialApp + ProviderScope for widget testing.
///
/// [overrides] lets you inject mock providers.
/// The widget is placed at route '/' by default.
Widget createTestApp(
  Widget child, {
  List<Override> overrides = const [],
  List<GoRoute> additionalRoutes = const [],
}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => child),
      // Stub routes so context.push() calls don't crash
      GoRoute(
        path: '/cart',
        builder: (_, __) => const Scaffold(body: Text('Cart Page')),
      ),
      GoRoute(
        path: '/checkout',
        builder: (_, __) => const Scaffold(body: Text('Checkout Page')),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (_, state) => Scaffold(
          body: Text('Product ${state.pathParameters['id']}'),
        ),
      ),
      ...additionalRoutes,
    ],
  );

  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      routerConfig: router,
    ),
  );
}
