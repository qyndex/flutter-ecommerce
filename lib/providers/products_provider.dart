import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/product.dart';

part 'products_provider.g.dart';

const _sampleProducts = [
  Product(
    id: '1', name: 'Wireless Headphones', category: 'Electronics',
    description: 'Premium wireless headphones with active noise cancellation and 30-hour battery life.',
    price: 149.99, imageUrl: 'https://picsum.photos/seed/headphones/400/300',
    rating: 4.5, reviewCount: 1240,
  ),
  Product(
    id: '2', name: 'Running Shoes', category: 'Sports',
    description: 'Lightweight running shoes with responsive cushioning for daily training.',
    price: 89.99, imageUrl: 'https://picsum.photos/seed/shoes/400/300',
    rating: 4.3, reviewCount: 876,
  ),
  Product(
    id: '3', name: 'Leather Backpack', category: 'Accessories',
    description: 'Genuine leather backpack with laptop compartment and waterproof lining.',
    price: 199.99, imageUrl: 'https://picsum.photos/seed/backpack/400/300',
    rating: 4.7, reviewCount: 342,
  ),
  Product(
    id: '4', name: 'Smart Watch', category: 'Electronics',
    description: 'Feature-rich smartwatch with health tracking and 5-day battery life.',
    price: 299.99, imageUrl: 'https://picsum.photos/seed/watch/400/300',
    rating: 4.6, reviewCount: 2103,
  ),
  Product(
    id: '5', name: 'Yoga Mat', category: 'Sports',
    description: 'Non-slip yoga mat with alignment lines and carrying strap.',
    price: 34.99, imageUrl: 'https://picsum.photos/seed/yoga/400/300',
    rating: 4.4, reviewCount: 519,
  ),
  Product(
    id: '6', name: 'Coffee Maker', category: 'Home',
    description: 'Programmable drip coffee maker with built-in grinder and thermal carafe.',
    price: 129.99, imageUrl: 'https://picsum.photos/seed/coffee/400/300',
    rating: 4.2, reviewCount: 988,
  ),
];

@riverpod
List<Product> products(Ref ref) => _sampleProducts;

@riverpod
Product? productById(Ref ref, String id) {
  return ref.watch(productsProvider).where((p) => p.id == id).firstOrNull;
}
