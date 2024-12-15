import 'package:supabase_flutter/supabase_flutter.dart';

class BusinessTable {
  final int? business_id; // Use nullable types if the fields can be null
  final String? business_name;
  final String? description;
  final String? email;
  final int? contact;
  final String? address;
  final String? image;
  final String? admin_id;

  BusinessTable({
    this.business_id,
    this.business_name,
    this.description,
    this.email,
    this.contact,
    this.address,
    this.image,
    this.admin_id,
  });

  // Factory constructor to create an instance from a Map
  factory BusinessTable.fromMap(Map<String, dynamic> data) {
    return BusinessTable(
      business_id: data['id'], // No need for default values if the type is nullable
      business_name: data['name'],
      description: data['description'],
      email: data['email'],
      contact: data['contact'],
      address: data['address'],
      image: data['image'],
      admin_id: data['admin_id'],
    );
  }

  // Optional: Method to convert instance back to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': business_id,
      'name': business_name,
      'description': description,
      'email': email,
      'contact': contact,
      'address': address,
      'image': image,
      'admin_id': admin_id,
    };
  }

  // Create a new business entry in the Supabase database
  static Future<void> createBusiness(BusinessTable business) async {

    final response = await Supabase.instance.client
        .from('businesses')
        .insert(business.toMap());

    if (response.error != null) {
      throw Exception('Failed to create business: ${response.error!.message}');
    }
  }

  // Read businesses from the Supabase database
  static Stream<List<BusinessTable>> fetchBusinessesStream() {
    final stream = Supabase.instance.client
        .from('businesses')
        .stream(primaryKey:['id']) // Primary key or unique column
        .map((data) => data.map((e) => BusinessTable.fromMap(e)).toList());

    return stream;
  }

  // Update an existing business entry
  static Future<void> updateBusiness(BusinessTable business) async {
    if (business.business_id == null) {
      throw Exception('Business ID is required to update a business');
    }

    final response = await Supabase.instance.client
        .from('businesses')
        .update(business.toMap())
        .eq('id', business.business_id ?? "0");


    if (response.error != null) {
      throw Exception('Failed to update business: ${response.error!.message}');
    }
  }

  // Delete a business entry from the database
  static Future<void> deleteBusiness(int businessId) async {
    final response = await Supabase.instance.client
        .from('businesses')
        .delete()
        .eq('id', businessId);
    if (response.error != null) {
      throw Exception('Failed to delete business: ${response.error!.message}');
    }
  }
}