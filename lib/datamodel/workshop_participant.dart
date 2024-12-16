import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkshopParticipant{

  final String? name;
  final String? workshop_name;
  final String? email;
  final int? phone_no;
  final int? age;
  final String? city;

  WorkshopParticipant({
    this.age,
    this.city,
    this.email,
    this.name,
    this.phone_no,
    this.workshop_name
  });
   // Create a WorkshopParticipant object from a map
  factory WorkshopParticipant.fromMap(Map<String, dynamic> map) {
    return WorkshopParticipant(
      age: map['age'],
      city: map['city'],
      email: map['email'],
      name: map['name'],
      phone_no: map['phone_no'],
      workshop_name: map['workshop_name'],
    );
  }

  // Convert a WorkshopParticipant object to a map
  Map<String, dynamic> toMap() {
    return {
      'age': age,
      'city': city,
      'email': email,
      'name': name,
      'phone_no': phone_no,
      'workshop_name': workshop_name,
    };
  }
  static Future<void> createWorkshopParticipant(WorkshopParticipant participantData) async {
  final response = await Supabase.instance.client
    .from('workshop_participants')
    .insert(participantData.toMap());

  if (response.error != null) {
    throw Exception('Failed to create workshop participant: ${response.error!.message}');
  }
}
}