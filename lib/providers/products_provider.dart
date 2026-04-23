import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/product.dart';
import '../services/supabase_client.dart';

part 'products_provider.g.dart';

/// Fetches all products from Supabase, ordered by creation date.
@riverpod
Future<List<Product>> products(Ref ref) async {
  final response = await supabase
      .from('products')
      .select()
      .order('created_at', ascending: false);

  return (response as List)
      .map((json) => Product.fromJson(json as Map<String, dynamic>))
      .toList();
}

/// Fetches products filtered by category.
@riverpod
Future<List<Product>> productsByCategory(Ref ref, String category) async {
  final response = await supabase
      .from('products')
      .select()
      .eq('category', category)
      .order('created_at', ascending: false);

  return (response as List)
      .map((json) => Product.fromJson(json as Map<String, dynamic>))
      .toList();
}

/// Fetches a single product by ID.
@riverpod
Future<Product?> productById(Ref ref, String id) async {
  final response = await supabase
      .from('products')
      .select()
      .eq('id', id)
      .maybeSingle();

  if (response == null) return null;
  return Product.fromJson(response);
}
