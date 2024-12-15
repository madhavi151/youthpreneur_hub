import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewDataModel {
  final int? product_id;
  final String? review;
  final String? rating;
  final String? user_id;

  ReviewDataModel({
    this.product_id,
    this.review,
    this.rating,
    this.user_id
  });

  // Factory constructor to create an instance from a Map
  factory ReviewDataModel.fromMap(Map<String, dynamic> data) {
    return ReviewDataModel(
        product_id: data['product_id'],
        review: data['review'],
        rating: data['rating'],
        user_id: data['user_id']
    );
  }

  // Method to convert instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'product_id': product_id,
      'review': review,
      'rating': rating,
      'user_id': user_id,
    };
  }

  // Create a new review in the database
  static Future<void> createReview(ReviewDataModel reviewData) async {
    final response = await Supabase.instance.client
        .from('reviews')
        .insert(reviewData.toMap());

    if (response.error != null) {
      throw Exception('Failed to create review: ${response.error!.message}');
    }
  }
//   await ReviewDataModel.createReview(
//   ReviewDataModel(
//     product_id: 1,
//     review: "Great product!",
//     rating: 5,
//   ),
// );


  // Fetch all reviews for a specific product
  static Stream<List<ReviewDataModel>> fetchReviews(int productId) {
    final stream = Supabase.instance.client
        .from('reviews')
        .stream(primaryKey: ['product_id'])
        .eq('product_id', productId)
        .map((data) =>
        data.map((e) => ReviewDataModel.fromMap(e)).toList());

    return stream;
  }
  //Example
//   StreamBuilder<List<ReviewDataModel>>(
//   stream: ReviewDataModel.fetchReviews(1), // Fetch reviews for product ID 1
//   builder: (context, snapshot) {
//     if (!snapshot.hasData) {
//       return const CircularProgressIndicator();
//     }

//     final reviews = snapshot.data!;
//     return ListView.builder(
//       itemCount: reviews.length,
//       itemBuilder: (context, index) {
//         final review = reviews[index];
//         return ListTile(
//           title: Text(review.review ?? 'No Review'),
//           subtitle: Text('Rating: ${review.rating ?? 0}'),
//         );
//       },
//     );
//   },
// );


  // Update an existing review
  static Future<void> updateReview(int productId, String newReview, int newRating) async {
    final response = await Supabase.instance.client
        .from('reviews')
        .update({'review': newReview, 'rating': newRating})
        .eq('product_id', productId);

    if (response.error != null) {
      throw Exception('Failed to update review: ${response.error!.message}');
    }
  }
//   await ReviewDataModel.updateReview(
//   1, // Product ID
//   "Amazing product with great quality!",
//   5, // New rating
// );


  // Delete a review
  static Future<void> deleteReview(int productId) async {
    final response = await Supabase.instance.client
        .from('reviews')
        .delete()
        .eq('product_id', productId);

    if (response.error != null) {
      throw Exception('Failed to delete review: ${response.error!.message}');
    }
  }
//await ReviewDataModel.deleteReview(1); // Deletes the review for product ID 1

}
