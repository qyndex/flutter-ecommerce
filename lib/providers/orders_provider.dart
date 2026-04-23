import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/product.dart';
import '../services/supabase_client.dart';

part 'orders_provider.g.dart';

/// A completed order with its line items.
class Order {
  final String id;
  final double total;
  final String status;
  final DateTime createdAt;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.total,
    required this.status,
    required this.createdAt,
    this.items = const [],
  });
}

class OrderItem {
  final String id;
  final String productId;
  final int quantity;
  final double unitPrice;

  const OrderItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => unitPrice * quantity;
}

/// Fetches the current user's orders from Supabase.
@riverpod
Future<List<Order>> orders(Ref ref) async {
  final user = supabase.auth.currentUser;
  if (user == null) return [];

  final response = await supabase
      .from('orders')
      .select('*, order_items(*)')
      .eq('user_id', user.id)
      .order('created_at', ascending: false);

  return (response as List).map((json) {
    final row = json as Map<String, dynamic>;
    final items = (row['order_items'] as List?)
            ?.map((i) {
              final item = i as Map<String, dynamic>;
              return OrderItem(
                id: item['id'] as String,
                productId: item['product_id'] as String,
                quantity: item['quantity'] as int,
                unitPrice: (item['unit_price'] as num).toDouble(),
              );
            })
            .toList() ??
        [];

    return Order(
      id: row['id'] as String,
      total: (row['total'] as num).toDouble(),
      status: row['status'] as String,
      createdAt: DateTime.parse(row['created_at'] as String),
      items: items,
    );
  }).toList();
}

/// Places a new order from the current cart items.
/// Returns the new order ID.
@riverpod
class PlaceOrder extends _$PlaceOrder {
  @override
  AsyncValue<String?> build() => const AsyncData(null);

  Future<String?> execute(List<CartItem> items) async {
    final user = supabase.auth.currentUser;
    if (user == null || items.isEmpty) return null;

    state = const AsyncLoading();

    try {
      final total = items.fold<double>(0, (sum, item) => sum + item.total);

      // Create the order
      final orderResponse = await supabase
          .from('orders')
          .insert({
            'user_id': user.id,
            'total': total,
            'status': 'pending',
          })
          .select('id')
          .single();

      final orderId = orderResponse['id'] as String;

      // Create order items
      final orderItems = items
          .map((item) => {
                'order_id': orderId,
                'product_id': item.product.id,
                'quantity': item.quantity,
                'unit_price': item.product.price,
              })
          .toList();

      await supabase.from('order_items').insert(orderItems);

      state = AsyncData(orderId);
      return orderId;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}
