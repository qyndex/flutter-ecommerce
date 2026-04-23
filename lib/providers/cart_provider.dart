import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/product.dart';
import '../services/supabase_client.dart';

part 'cart_provider.g.dart';

/// Manages the user's shopping cart backed by Supabase cart_items table.
///
/// When the user is signed in, cart operations persist to the database.
/// Falls back to local-only state for anonymous browsing.
@riverpod
class Cart extends _$Cart {
  @override
  List<CartItem> build() => [];

  /// Load cart items from Supabase for the signed-in user.
  Future<void> loadFromSupabase() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase
        .from('cart_items')
        .select('id, quantity, products(*)')
        .eq('user_id', user.id)
        .order('created_at');

    state = (response as List).map((row) {
      final json = row as Map<String, dynamic>;
      return CartItem(
        id: json['id'] as String,
        product: Product.fromJson(json['products'] as Map<String, dynamic>),
        quantity: json['quantity'] as int,
      );
    }).toList();
  }

  /// Add a product to the cart. Upserts in Supabase if signed in.
  Future<void> addItem(Product product) async {
    // Optimistic local update
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final updated = List<CartItem>.from(state);
      updated[index] =
          updated[index].copyWith(quantity: updated[index].quantity + 1);
      state = updated;
    } else {
      state = [...state, CartItem(product: product, quantity: 1)];
    }

    // Persist to Supabase
    final user = supabase.auth.currentUser;
    if (user != null) {
      await supabase.from('cart_items').upsert(
        {
          'user_id': user.id,
          'product_id': product.id,
          'quantity':
              state.firstWhere((i) => i.product.id == product.id).quantity,
        },
        onConflict: 'user_id,product_id',
      );
      // Reload to get server-generated IDs
      await loadFromSupabase();
    }
  }

  /// Remove a product from the cart entirely.
  Future<void> removeItem(String productId) async {
    state = state.where((item) => item.product.id != productId).toList();

    final user = supabase.auth.currentUser;
    if (user != null) {
      await supabase
          .from('cart_items')
          .delete()
          .eq('user_id', user.id)
          .eq('product_id', productId);
    }
  }

  /// Update quantity for a specific product. Removes if quantity <= 0.
  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeItem(productId);
      return;
    }

    state = state.map((item) {
      return item.product.id == productId
          ? item.copyWith(quantity: quantity)
          : item;
    }).toList();

    final user = supabase.auth.currentUser;
    if (user != null) {
      await supabase
          .from('cart_items')
          .update({'quantity': quantity})
          .eq('user_id', user.id)
          .eq('product_id', productId);
    }
  }

  /// Clear all items from the cart.
  Future<void> clear() async {
    state = [];

    final user = supabase.auth.currentUser;
    if (user != null) {
      await supabase
          .from('cart_items')
          .delete()
          .eq('user_id', user.id);
    }
  }

  double get subtotal => state.fold(0, (sum, item) => sum + item.total);
  int get itemCount => state.fold(0, (sum, item) => sum + item.quantity);
}
