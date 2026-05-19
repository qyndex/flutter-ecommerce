import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/product.dart';

part 'products_provider.g.dart';

/// Sample product catalog for demo deployment.
///
/// The Supabase-backed version lives in git history; the public demo runs
/// without a backend so we serve a fixed catalog. Swap with a Supabase fetch
/// in production by re-adding `services/supabase_client.dart` and making this
/// provider async.
const _sampleProducts = <Product>[
  Product(
    id: '1',
    name: 'Wireless Headphones',
    description: 'Premium noise-cancelling over-ear headphones with 30h battery.',
    price: 199.99,
    imageUrl: '',
    category: 'Audio',
    rating: 4.6,
    reviewCount: 1284,
    stockCount: 42,
  ),
  Product(
    id: '2',
    name: 'Smart Watch',
    description: 'Fitness tracking, heart-rate, and notifications on a sapphire display.',
    price: 299.00,
    imageUrl: '',
    category: 'Wearables',
    rating: 4.4,
    reviewCount: 932,
    stockCount: 18,
  ),
  Product(
    id: '3',
    name: 'Mechanical Keyboard',
    description: 'Hot-swappable switches, RGB per-key, aluminum chassis.',
    price: 149.50,
    imageUrl: '',
    category: 'Accessories',
    rating: 4.8,
    reviewCount: 2104,
    stockCount: 75,
  ),
  Product(
    id: '4',
    name: 'USB-C Hub',
    description: '8-in-1 hub: HDMI 4K, Ethernet, SD, 3× USB-A, 100W PD.',
    price: 59.99,
    imageUrl: '',
    category: 'Accessories',
    rating: 4.3,
    reviewCount: 487,
    stockCount: 120,
  ),
  Product(
    id: '5',
    name: 'Portable SSD 1TB',
    description: 'USB 3.2 Gen 2, 1050 MB/s read, ruggedized shell.',
    price: 119.00,
    imageUrl: '',
    category: 'Storage',
    rating: 4.7,
    reviewCount: 678,
    stockCount: 33,
  ),
  Product(
    id: '6',
    name: 'Webcam 4K',
    description: 'Autofocus, dual-mic, privacy shutter — plug and play.',
    price: 89.99,
    imageUrl: '',
    category: 'Video',
    rating: 4.2,
    reviewCount: 312,
    stockCount: 55,
  ),
];

/// Returns the full product catalog.
@riverpod
List<Product> products(Ref ref) => _sampleProducts;

/// Returns products filtered by category.
@riverpod
List<Product> productsByCategory(Ref ref, String category) =>
    _sampleProducts.where((p) => p.category == category).toList();

/// Returns a single product by id, or null if not found.
@riverpod
Product? productById(Ref ref, String id) {
  for (final p in _sampleProducts) {
    if (p.id == id) return p;
  }
  return null;
}
