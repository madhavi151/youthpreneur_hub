import 'package:supabase_flutter/supabase_flutter.dart';

class ServicesDataModel {
  final String? image;
  final String? service_name;
  final String? description;
  final String? email;
  final int? contact;
  final String? address;
  final int? service_id;

  ServicesDataModel({
    this.image,
    this.service_name,
    this.description,
    this.email,
    this.contact,
    this.address,
    this.service_id,
  });

  // Factory constructor to create an instance from a Map
  factory ServicesDataModel.fromMap(Map<String, dynamic> data) {
    return ServicesDataModel(
      image: data['image'],
      service_name: data['name'],
      description: data['description'],
      email: data['email_id'],
      contact: data['contact'],
      address: data['address'],
      service_id: data['service_id'],
    );
  }

  // Method to convert instance back to a Map
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': service_name,
      'description': description,
      'email_id': email,
      'contact': contact,
      'address': address,
      'service_id': service_id,
    };
  }

  // Create a new service in the database
  static Future<void> createService(ServicesDataModel service) async {
    final response = await Supabase.instance.client
        .from('services')
        .insert(service.toMap());

    if (response.error != null) {
      throw Exception('Failed to create service: ${response.error!.message}');
    }
  }
//   await ServicesDataModel.createService(
//   ServicesDataModel(
//     image: 'https://example.com/image.jpg',
//     service_name: 'Cleaning Service',
//     description: 'Professional cleaning services for your home and office.',
//     email: 'contact@example.com',
//     contact: 1234567890,
//     address: '123 Main Street',
//   ),
// );


  // Fetch all services as a stream
  static Stream<List<ServicesDataModel>> fetchServicesStreamById(int service_id) {
    final stream = Supabase.instance.client
        .from('services')
        .stream(primaryKey: ['id'])
        .eq('service_id', service_id)
        .map((data) =>
        data.map((e) => ServicesDataModel.fromMap(e)).toList());

    return stream;
  }
  static Stream<List<ServicesDataModel>> fetchServicesStream() {
    final stream = Supabase.instance.client
        .from('services')
        .stream(primaryKey: ['id'])
        .map((data) =>
        data.map((e) => ServicesDataModel.fromMap(e)).toList());

    return stream;
  }
//   StreamBuilder<List<ServicesDataModel>>(
//   stream: ServicesDataModel.fetchServicesStream(),
//   builder: (context, snapshot) {
//     if (!snapshot.hasData) {
//       return const CircularProgressIndicator();
//     }

//     final services = snapshot.data!;
//     return ListView.builder(
//       itemCount: services.length,
//       itemBuilder: (context, index) {
//         final service = services[index];
//         return ListTile(
//           title: Text(service.service_name ?? 'No Name'),
//           subtitle: Text(service.description ?? 'No Description'),
//           leading: service.image != null
//               ? Image.network(service.image!)
//               : const Icon(Icons.business),
//         );
//       },
//     );
//   },
// );


  // Fetch details of a specific service by ID
  /*static Future<ServicesDataModel?> fetchServiceById(int serviceId) async {
    final response = await Supabase.instance.client
        .from('services')
        .select()
        .eq('service_id', serviceId);

    if (response.error != null) {
      throw Exception('Failed to fetch service: ${response.error!.message}');
    }

    if (response.data != null) {
      return ServicesDataModel.fromMap(response.data);
    } else {
      return null;
    }
  }*/

  // Update an existing service entry
  static Future<void> updateService(ServicesDataModel service) async {
    if (service.service_id == null) {
      throw Exception('Service ID is required to update a service');
    }

    final response = await Supabase.instance.client
        .from('services')
        .update(service.toMap())
        .eq('service_id', service.service_id ?? '0');

    if (response.error != null) {
      throw Exception('Failed to update service: ${response.error!.message}');
    }
  }
//   await ServicesDataModel.updateService(
//   ServicesDataModel(
//     service_id: 1,
//     service_name: 'Updated Cleaning Service',
//     description: 'Updated description.',
//     contact: 9876543210,
//   ),
// );


  // Delete a service entry from the database
  static Future<void> deleteService(int serviceId) async {
    final response = await Supabase.instance.client
        .from('services')
        .delete()
        .eq('service_id', serviceId);

    if (response.error != null) {
      throw Exception('Failed to delete service: ${response.error!.message}');
    }
  }
}
