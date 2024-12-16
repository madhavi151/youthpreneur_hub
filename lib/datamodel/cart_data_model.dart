import 'package:supabase_flutter/supabase_flutter.dart';

class CartDataModel {
  final String? product_name;
  final int? price;
  final String? user_id;
  final int? product_id;
  final String? image;
  final String? business_name;

  CartDataModel({
    this.product_id,
    this.product_name,
    this.price,
    this.user_id,
    this.image,
    this.business_name
  });

  // Factory constructor to create an instance from a Map
  factory CartDataModel.fromMap(Map<String, dynamic> data) {
    return CartDataModel(
        product_id: data['product_id'],
        product_name: data['product'],
        price: data['price'],
        user_id: data['user_id'],
        image: data['image'],
        business_name: data['business_name']
    );
  }

  // Method to convert instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'product_id': product_id,
      'product': product_name,
      'price': price,
      'user_id': user_id,
      'image':image,
      'business_name':business_name
    };
  }
  // Check if a specific product is in the cart
  static Future<bool> isProductInCart(int productId, String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('cart')
          .select()
          .eq('product_id', productId)
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        return false;
      }

      // Check if the response contains data
      return response.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check product in cart: $e');
    }
  }

  // Create a new cart entry in the database
  static Future<void> addToCart(CartDataModel cartItem) async {
    final response = await Supabase.instance.client
        .from('cart')
        .insert(cartItem.toMap());

    if (response.error != null) {
      throw Exception('Failed to add item to cart: ${response.error!.message}');
    }
  }
// await CartDataModel.addToCart(CartDataModel(
//   product_id: 1,
//   product_name: "Product A",
//   quantity: 2,
//   user_id: "user123",
// ));


  // Fetch cart items for a specific user
  static Stream<List<CartDataModel>> fetchCartItems(String userId) {
    final stream = Supabase.instance.client
        .from('cart')
        .stream(primaryKey: ['product_id'])
        .eq('user_id', userId)
        .map((data) =>
        data.map((e) => CartDataModel.fromMap(e)).toList());

    return stream;
  }

  // Update cart item quantity
  static Future<void> updateQuantity(int productId, int newQuantity) async {
    final response = await Supabase.instance.client
        .from('cart')
        .update({'quantity': newQuantity})
        .eq('product_id', productId);

    if (response.error != null) {
      throw Exception('Failed to update cart quantity: ${response.error!.message}');
    }
  }//await CartDataModel.updateQuantity(1, 3); // Updates product with ID 1 to quantity 3



  // Remove a cart item
  static Future<void> removeFromCart(int productId) async {
    final response = await Supabase.instance.client
        .from('cart')
        .delete()
        .eq('product_id', productId);

    if (response.error != null) {
      throw Exception('Failed to remove item from cart: ${response.error!.message}');
    }
  }//await CartDataModel.removeFromCart(1); // Removes product with ID 1
}
