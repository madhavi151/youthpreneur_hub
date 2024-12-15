import 'package:Youthpreneur_Hub/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../datamodel/cart_data_model.dart';
import '../datamodel/review_data_model.dart';

class ProductDetail extends StatefulWidget {
  final int product_id;
  final String image;
  final String name;
  final String description;
  final int price;

  const ProductDetail({
    super.key,
    required this.product_id,
    required this.description,
    required this.image,
    required this.name,
    required this.price,
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
          user_id: 'kevin'
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
            user_id: '',
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
        title: Text(widget.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.image,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
                ),
              ),
              const SizedBox(height: 16),
              // Product Name and Price
              Text(widget.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("\₹${widget.price}",
                  style: const TextStyle(fontSize: 20, color: Colors.green)),
              const SizedBox(height: 16),
              // Product Description
              Text(widget.description),
              const SizedBox(height: 16),
              // Add/Remove to Cart Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  if (_isInCart == true) {
                    await _removeProductFromCart();
                  } else {
                    await _addProductInCart();
                  }
                  _checkProductInCart();
                },
                child: Text(
                  _isInCart == null
                      ? "Loading..."
                      : _isInCart!
                      ? "Remove from Cart"
                      : "Add to Cart",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

              const Text("R E V I E W S", style: TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              // Reviews Section
              Container(
                child: SingleChildScrollView(
                  child: StreamBuilder<List<ReviewDataModel>>(
                    stream: ReviewDataModel.fetchReviews(widget.product_id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No reviews yet.'));
                      }
                      final reviews = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviews[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                review.user_id ?? '',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(review.review ?? ''),
                                  Text('Rating: ${review.rating}',
                                      style: const TextStyle(color: Colors.orange)),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Write Review Section
              const Text("Write a Review", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
              TextField(
                controller: _reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  hintText: 'Write your review here...',
                ),
              ),
              const SizedBox(height: 10),
              // Rating Dropdown
              Row(
                children: [
                  const Text("Rating:", style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  DropdownButton<double>(
                    value: _rating,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _rating = value;
                        });
                      }
                    },
                    items: List.generate(5, (index) => index + 1)
                        .map((value) => DropdownMenuItem(
                      value: value.toDouble(),
                      child: Text(value.toString()),
                    ))
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _submitReview,
                child: const Text("Submit Review"),
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
