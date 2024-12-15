import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceProductDataModel {
  final String? image;
  final String? product_name;
  final String? description;
  final String? price;
  final int? service_id;

  ServiceProductDataModel({
    this.description,
    this.image,
    this.price,
    this.product_name,
    this.service_id,
  });

  // Factory constructor to create an instance from a Map
  factory ServiceProductDataModel.fromMap(Map<String, dynamic> data) {
    return ServiceProductDataModel(
      image: data['image'],
      product_name: data['product_name'],
      description: data['description'],
      price: data['price'],
      service_id: data['service_id'],
    );
  }

  // Method to convert instance back to a Map
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'product_name': product_name,
      'description': description,
      'price': price,
      'service_id': service_id,
    };
  }

  // Create a new service product entry in the database
  static Future<void> createServiceProduct(ServiceProductDataModel product) async {
    final response = await Supabase.instance.client
        .from('service_products')
        .insert(product.toMap());

    if (response.error != null) {
      throw Exception('Failed to create service product: ${response.error!.message}');
    }
  }
//   await ServiceProductDataModel.createServiceProduct(
//   ServiceProductDataModel(
//     image: 'https://example.com/image.jpg',
//     product_name: 'Premium Cleaning Kit',
//     description: 'A complete cleaning kit for professional services.',
//     price: '500',
//     service_id: 1,
//   ),
// );


  // Fetch all service products for a specific service as a stream
  static Stream<List<ServiceProductDataModel>> fetchServiceProductsStreamById(int serviceId) {
    final stream = Supabase.instance.client
        .from('service products')
        .stream(primaryKey: ['service_id'])
        .eq('service_id', serviceId)
        .map((data) =>
        data.map((e) => ServiceProductDataModel.fromMap(e)).toList());

    return stream;
  }

  static Stream<List<ServiceProductDataModel>> fetchServiceProductsStream() {
    final stream = Supabase.instance.client
        .from('service products')
        .stream(primaryKey: ['service_id'])
        .map((data) =>
        data.map((e) => ServiceProductDataModel.fromMap(e)).toList());

    return stream;
  }
//   StreamBuilder<List<ServiceProductDataModel>>(
//   stream: ServiceProductDataModel.fetchServiceProductsStream(1), // Replace with your service_id
//   builder: (context, snapshot) {
//     if (!snapshot.hasData) {
//       return const CircularProgressIndicator();
//     }

//     final products = snapshot.data!;
//     return ListView.builder(
//       itemCount: products.length,
//       itemBuilder: (context, index) {
//         final product = products[index];
//         return ListTile(
//           title: Text(product.product_name ?? 'No Name'),
//           subtitle: Text(product.description ?? 'No Description'),
//           trailing: Text("\₹${product.price}"),
//         );
//       },
//     );
//   },
// );




  // Update an existing service product entry
  static Future<void> updateServiceProduct(ServiceProductDataModel product) async {
    if (product.service_id == null) {
      throw Exception('Service ID is required to update a service product');
    }

    final response = await Supabase.instance.client
        .from('service_products')
        .update(product.toMap())
        .eq('service_id', product.service_id ?? '');

    if (response.error != null) {
      throw Exception('Failed to update service product: ${response.error!.message}');
    }
  }

//   await ServiceProductDataModel.updateServiceProduct(
//   ServiceProductDataModel(
//     service_id: 1,
//     product_name: 'Updated Cleaning Kit',
//     description: 'Updated description of the product.',
//     price: '600',
//   ),
// );


  // Delete a service product entry from the database
  static Future<void> deleteServiceProduct(int productId) async {
    final response = await Supabase.instance.client
        .from('service_products')
        .delete()
        .eq('product_id', productId);

    if (response.error != null) {
      throw Exception('Failed to delete service product: ${response.error!.message}');
    }
  }
//await ServiceProductDataModel.deleteServiceProduct(1);

}
