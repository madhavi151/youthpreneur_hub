import 'package:supabase_flutter/supabase_flutter.dart';

class WorkshopDataModel {
  final String workshopName;
  final String description;
  final String date;
  final String time;
  final String duration;
  final String location;
  final int maxPeople;
  final String image;
  final String instructorName;
  final String cost;

  WorkshopDataModel({
    required this.workshopName,
    required this.description,
    required this.date,
    required this.time,
    required this.duration,
    required this.location,
    required this.maxPeople,
    required this.image,
    required this.instructorName,
    required this.cost,
  });

  // Factory constructor to create a WorkshopDataModel from a Map (e.g., from a database)
  factory WorkshopDataModel.fromMap(Map<String, dynamic> data) {
    return WorkshopDataModel(
      workshopName: data['workshop_name'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      duration: data['duration'] ?? '',
      location: data['location'] ?? '',
      maxPeople: int.tryParse(data['max_people']?.toString() ?? '0') ?? 0,
      image: data['image'] ?? '',
      instructorName: data['instructor_name'] ?? '',
      cost: data['cost']
    );
  }

  // Convert WorkshopDataModel to a Map for database or API usage
  Map<String, dynamic> toMap() {
    return {
      'workshop_name': workshopName,
      'description': description,
      'date': date,
      'time': time,
      'duration': duration,
      'location': location,
      'max_people': maxPeople,
      'image': image,
      'instructor_name': instructorName,
      'cost':cost
    };
  }

  static Stream<List<WorkshopDataModel>> fetchWorkshopStream() {
  final stream = Supabase.instance.client
    .from('workshop')
    .stream(primaryKey: ['id'])
    .map((data) =>
    data.map((e) => WorkshopDataModel.fromMap(e)).toList());

  return stream;
}
  
}
