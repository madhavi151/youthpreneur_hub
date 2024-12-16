import 'package:Youthpreneur_Hub/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datamodel/cart_data_model.dart';
import '../datamodel/review_data_model.dart';
import 'package:Youthpreneur_Hub/services/ttsservice.dart';

class ProductDetail extends StatefulWidget {
  final int product_id;
  final String image;
  final String name;
  final String description;
  final int price;
  final String business_name;

  const ProductDetail({
    super.key,
    required this.product_id,
    required this.description,
    required this.image,
    required this.name,
    required this.price,
    required this.business_name
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool? _isInCart;
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 5.0; // Default rating

  @override
  void initState() {
    super.initState();
    _checkProductInCart();
    _loadUserData();
  }
  late String email;
  Future<void> _loadUserData() async {

    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      final user = session.user;
      email = user.email ?? 'No email';

    } else {
      email = 'No email';

    }
    setState(() {});
  }
  Future<void> _checkProductInCart() async {
    try {
      bool result = await CartDataModel.isProductInCart(widget.product_id, 'kevin');
      setState(() {
        _isInCart = result;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _addProductInCart() async {
    try {
      await CartDataModel.addToCart(CartDataModel(
          product_id: widget.product_id,
          product_name: widget.name,
          price: widget.price,
          image: widget.image,
          user_id: email,
          business_name: widget.business_name,
      ));
      setState(() {
        _isInCart = true; // Update state after adding
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _removeProductFromCart() async {
    try {
      await CartDataModel.removeFromCart(widget.product_id);
      setState(() {
        _isInCart = false; // Update state after removing
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _submitReview() async {
    try {
      // final review = ReviewDataModel(
      //   product_id: widget.product_id,
      //   user_id: 'kevin',
      //   review: _reviewController.text,
      //   rating: _rating.toString(),
      // );
      // await ReviewDataModel.createReview(review);
      final user_id = AuthService().getCurrentUser();
      await ReviewDataModel.createReview(
        ReviewDataModel(
            product_id: widget.product_id,
            review: _reviewController.text,
            rating: _rating.toString(),
            user_id: email,

        ),
      );
      _reviewController.clear(); // Clear the input field after submission
      setState(() {}); // Refresh the UI to display the new review
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 2,
        shadowColor: Colors.grey[300],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.image,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                  ),
                ),
              ),
              // Product Details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "₹${widget.price}",
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Add to Cart Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(
                          _isInCart == true ? Icons.remove_shopping_cart : Icons.add_shopping_cart,
                          color: Colors.white,
                        ),
                        label: Text(
                          _isInCart == null
                              ? "Loading..."
                              : _isInCart!
                              ? "Remove from Cart"
                              : "Add to Cart",
                          style: const TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          _isInCart == true ? Colors.redAccent : Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () async {
                          if (_isInCart == true) {
                            await _removeProductFromCart();
                          } else {
                            await _addProductInCart();
                          }
                          _checkProductInCart();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Reviews Section
              Text(
                "Customer Reviews",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: StreamBuilder<List<ReviewDataModel>>(
                  stream: ReviewDataModel.fetchReviews(widget.product_id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No reviews yet.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }
                    final reviews = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final review = reviews[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person, color: Colors.grey[600]),
                                  const SizedBox(width: 8),
                                  Text(
                                    review.user_id ?? 'Anonymous',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                review.review ?? '',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text("Rating: ",
                                      style: TextStyle(color: Colors.grey)),
                                  Icon(Icons.star,
                                      color: Colors.orange, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${review.rating}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Write a Review
              Text(
                "Write a Review",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Write your review...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Submit Review Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _submitReview,
                child: const Text("Submit Review",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );

  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
