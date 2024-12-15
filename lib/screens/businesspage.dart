import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Youthpreneur_Hub/datamodel/business_data_model.dart';

import 'product_list.dart';




class BusinessScreen extends StatefulWidget {
  const BusinessScreen({super.key});

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {

  Stream<List<Map<String, dynamic>>> get businessStream =>
      Supabase.instance.client.from('businesses').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<BusinessTable>>(
        stream: BusinessTable.fetchBusinessesStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final businesses = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0), // Add padding around the content
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Businesses',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 250, // Fixed height for the horizontal list
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal, // Horizontal scrolling
                    itemCount: businesses.length,
                    itemBuilder: (context, index) {
                      final business = businesses[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>ProductList(
                                business: business.business_name ?? '',
                                image: business.image!,
                                description: business.description!,
                                email: business.email!,
                                contact: business.contact!,
                                address: business.address!,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 8.0, // Card elevation
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.only(right: 16.0), // Add spacing between cards
                          child: Container(
                            width: 180, // Same fixed width for all cards
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: Colors.white, // Card background color
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Business Image
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16.0),
                                  ),
                                  child: business.image != null
                                      ? Image.network(
                                    business.image!,
                                    height: 150, // Fixed image height
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 80),
                                  )
                                      : const Icon(Icons.business, size: 80),
                                ),
                                const SizedBox(height: 8),
                                // Business Name
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    business.business_name ?? 'Business Name',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Business Description
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    business.description ?? 'No description available.',
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );



  }
}