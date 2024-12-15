import 'package:supabase_flutter/supabase_flutter.dart';

class ProductDataModel {
  final int? product_id;
  final String? business_name;
  final String? product_name;
  final int? price;
  final String? image;
  final String? description;
  final String? cart_status;

  ProductDataModel({
    this.product_id,
    this.business_name,
    this.product_name,
    this.price,
    this.image,
    this.description,
    this.cart_status,
  });

  // Factory constructor to create an instance from a Map
  factory ProductDataModel.fromMap(Map<String, dynamic> data) {
    return ProductDataModel(
      product_id: data['product_id'],
      business_name: data['business_id'],
      product_name: data['name'],
      price: data['price'],
      image: data['product_image'],
      description: data['description'],
      cart_status: data['cart_status'],
    );
  }

  // Method to convert instance back to a Map
  Map<String, dynamic> toMap() {
    return {
      'product_id': product_id,
      'business_name': business_name,
      'product_name': product_name,
      'price': price,
      'image': image,
      'description': description,
      'cart_status': cart_status,
    };
  }

  // Create a new product entry in the Supabase database
  static Future<void> createProduct(ProductDataModel product) async {
    final response = await Supabase.instance.client
        .from('products')
        .insert(product.toMap());

    if (response.error != null) {
      throw Exception('Failed to create product: ${response.error!.message}');
    }
  }

  // Read products from the Supabase database
  static Stream<List<ProductDataModel>> fetchProductsStream() {
    final stream = Supabase.instance.client
        .from('products')
        .stream(primaryKey: ['id'])
        .map((data) => data.map((e) => ProductDataModel.fromMap(e)).toList());

    return stream;
  }
  static Stream<List<ProductDataModel>> fetchProductByName(String businessId) {
    final stream = Supabase.instance.client
        .from('products')
        .stream(primaryKey: ['id'])
        .eq('business_id', businessId) // Filter by product_id
        .map((data) =>data.map((e) => ProductDataModel.fromMap(e)).toList());

    return stream;
  }

  static Stream<List<ProductDataModel>> fetchProductById(String productId) {
    final stream = Supabase.instance.client
        .from('products')
        .stream(primaryKey: ['id'])
        .eq('id', productId) // Filter by product_id
        .map((data) => data.map((e) => ProductDataModel.fromMap(e)).toList());

    return stream;
  }


  // Update an existing product entry
  static Future<void> updateProduct(ProductDataModel product) async {
    if (product.product_id == null) {
      throw Exception('Product ID is required to update a product');
    }

    final response = await Supabase.instance.client
        .from('products')
        .update(product.toMap())
        .eq('product_id', product.product_id ?? '');

    if (response.error != null) {
      throw Exception('Failed to update product: ${response.error!.message}');
    }
  }

  // Delete a product entry from the database
  static Future<void> deleteProduct(int productId) async {
    final response = await Supabase.instance.client
        .from('products')
        .delete()
        .eq('product_id', productId);

    if (response.error != null) {
      throw Exception('Failed to delete product: ${response.error!.message}');
    }
  }
}
