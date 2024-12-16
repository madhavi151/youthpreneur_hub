import 'package:supabase_flutter/supabase_flutter.dart';

class OrderDataModel{
  final String? customer_name;
  final String? customer_email;
  final String? phone_no;
  final String? product_name;
  final int? quantity;
  final String? price;
  final String? address;
  final String? status;
  final String? reason;
  final String? mode;
  final String? business_name;

  OrderDataModel({
    this.address,
    this.customer_email,
    this.customer_name,
    this.mode,
    this.phone_no,
    this.price,
    this.product_name,
    this.quantity,
    this.reason,
    this.status,
    this.business_name
  });

  factory OrderDataModel.fromMap(Map<String, dynamic> data) {
  return OrderDataModel(
    customer_name: data['customer_name'],
    customer_email: data['customer_email'],
    phone_no: data['phone_no'],
    product_name: data['product_name'],
    quantity: data['quantity'],
    price: data['price'],
    address: data['address'],
    status: data['status'],
    reason: data['reason'],
    mode: data['mode'],
    business_name: data['business_id']
  );
}

Map<String, dynamic> toMap() {
  return {
    'customer_name': customer_name,
    'customer_email': customer_email,
    'phone_no': phone_no,
    'product_name': product_name,
    'quantity': quantity,
    'price': price,
    'address': address,
    'status': status,
    'reason': reason,
    'mode': mode,
    'business_id':business_name
  };
}

// Create a new order
static Future<void> createOrder(OrderDataModel order) async {
  final response = await Supabase.instance.client
      .from('orders')
      .insert(order.toMap());

  if (response.error != null) {
    throw Exception('Failed to create order: ${response.error!.message}');
  }
}

// final newOrder = OrderDataModel(
//   customer_name: "John Doe",
//   customer_email: "john@example.com",
//   phone_no: "9876543210",
//   product_name: "Smartphone",
//   quantity: 2,
//   price: "29999",
//   address: "123 Elm Street",
//   mode: "Online",
// );

// await OrderDataModel.createOrder(newOrder);

// Fetch all orders
static Stream<List<OrderDataModel>> fetchOrders() {
  final stream = Supabase.instance.client
      .from('orders')
      .stream(primaryKey: ['id'])
      .map((data) => data.map((e) => OrderDataModel.fromMap(e)).toList());

  return stream;
}

// Update an order
static Future<void> updateOrder(int orderId, OrderDataModel order) async {
  final response = await Supabase.instance.client
      .from('orders')
      .update(order.toMap())
      .eq('id', orderId);

  if (response.error != null) {
    throw Exception('Failed to update order: ${response.error!.message}');
  }
}

// Delete an order
static Future<void> deleteOrder(int orderId) async {
  final response = await Supabase.instance.client
      .from('orders')
      .delete()
      .eq('id', orderId);

  if (response.error != null) {
    throw Exception('Failed to delete order: ${response.error!.message}');
  }
}


}