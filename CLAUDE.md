# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter E-commerce -- a mobile/web shop app with product browsing, cart management, and checkout. Built with Flutter 3.24+, Dart 3.5+, Riverpod (code-gen) for state management, GoRouter for navigation, and Dio for HTTP.

## Commands

```bash
# Dependencies
flutter pub get                    # Install dependencies
dart run build_runner build        # Generate Riverpod .g.dart files (required after provider changes)

# Development
flutter run                        # Run on connected device/emulator
flutter run -d chrome              # Run web version in Chrome
flutter run -d macos               # Run desktop (macOS)

# Testing
flutter test                       # Run all tests
flutter test test/models/          # Run model unit tests only
flutter test test/providers/       # Run provider tests only
flutter test test/screens/         # Run widget tests only
flutter test --coverage            # Run tests with coverage report

# Quality
flutter analyze                    # Static analysis (uses analysis_options.yaml)
dart format .                      # Format all Dart files
dart format --set-exit-if-changed . # Format check (CI mode)

# Build
flutter build apk                  # Android APK
flutter build ios                  # iOS (macOS only)
flutter build web --release        # Web (used in Dockerfile)
```

## Architecture

```
lib/
  main.dart                         # Entry point: ProviderScope wraps EcommerceApp
  app.dart                          # EcommerceApp widget + GoRouter config
  models/
    product.dart                    # Product and CartItem data classes
  providers/
    cart_provider.dart              # Cart state (Riverpod code-gen @riverpod notifier)
    products_provider.dart          # Product catalog (Riverpod code-gen @riverpod)
  screens/
    product_grid_screen.dart        # Home: 2-column grid of product cards
    product_detail_screen.dart      # Single product view with Add to Cart
    cart_screen.dart                # Cart list with quantity controls
    checkout_screen.dart            # Shipping + payment form, order placement
  services/
    api_service.dart                # Dio HTTP client (GET/POST/PUT/DELETE)
test/
  helpers/
    test_helpers.dart               # createTestApp() -- ProviderScope + GoRouter wrapper
  models/
    product_test.dart               # Product/CartItem unit tests
  providers/
    cart_provider_test.dart         # Cart add/remove/update/clear/subtotal tests
    products_provider_test.dart     # Catalog + productById tests
  screens/
    product_grid_screen_test.dart   # Grid rendering, navigation, empty state
    cart_screen_test.dart           # Cart display, empty state, quantity controls
    checkout_screen_test.dart       # Form validation, order placement flow
    product_detail_screen_test.dart # Detail rendering, add-to-cart, not-found
  services/
    api_service_test.dart           # ApiService instantiation and API surface
```

## State Management

- **Riverpod with code-gen** (`@riverpod` annotations in providers/). After changing any provider file, run `dart run build_runner build` to regenerate `.g.dart` files.
- `cartProvider` -- mutable notifier (`Cart extends _$Cart`) managing `List<CartItem>`. Methods: `addItem`, `removeItem`, `updateQuantity`, `clear`. Getters: `subtotal`, `itemCount`.
- `productsProvider` -- read-only list of sample `Product` objects.
- `productByIdProvider(String id)` -- family provider returning a single `Product?`.

## Navigation

GoRouter with four routes:
- `/` -- ProductGridScreen (home)
- `/product/:id` -- ProductDetailScreen
- `/cart` -- CartScreen
- `/checkout` -- CheckoutScreen

## Environment Variables

Copy `.env.example` to `.env` and set values. Key variables:
- `API_BASE_URL` -- Backend API root (default: `https://api.example.com`)
- `API_KEY` -- Backend auth key
- `STRIPE_PUBLISHABLE_KEY` -- Payment processing
- `SENTRY_DSN` -- Crash reporting (optional)
- `APP_ENV` -- `development` / `staging` / `production`

## Testing Conventions

- **Test helper**: `test/helpers/test_helpers.dart` provides `createTestApp()` which wraps widgets in `ProviderScope` + `MaterialApp.router` with stub routes for `/cart`, `/checkout`, `/product/:id`.
- **Provider overrides**: Use `overrides` parameter in `createTestApp()` to inject test data. For `Cart` notifier, subclass `Cart` and override `build()` to return initial items.
- **Model tests**: Pure Dart, no Flutter dependency.
- **Provider tests**: Use `ProviderContainer` directly -- no widget tree needed.
- **Widget tests**: Use `tester.pumpWidget(createTestApp(...))` with provider overrides.
- Test files mirror `lib/` structure under `test/`.

## Rules

- Use `StatelessWidget` (or `ConsumerWidget`) unless local mutable state is needed
- Riverpod for all shared state -- never raw `setState` for data that crosses widget boundaries
- All widgets should be const-constructible where possible
- Follow Effective Dart style guide
- Separate business logic from UI: logic in providers, display in screens/widgets
- Always use `apiFetch`-style typed calls via `ApiService` -- never raw `http.get()`
- Run `flutter analyze` before committing -- zero warnings policy
- Run `dart run build_runner build` after modifying any `@riverpod`-annotated file
- `.env` is gitignored -- never commit secrets; use `.env.example` as the template
