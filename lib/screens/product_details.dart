import 'package:flutter/material.dart';

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
  List<Map<String, dynamic>> cart = [];

  bool _isInCart() {
    return cart.any((item) => item['product_id'] == widget.product_id);
  }

  void _addToCart() {
    setState(() {
      if (!_isInCart()) {
        cart.add({
          'product_id': widget.product_id,
          'name': widget.name,
          'price': widget.price,
          'quantity': 1,
          'image': widget.image,
        });
      }
    });
  }

  void _increaseQuantity() {
    setState(() {
      int index = cart.indexWhere((item) => item['product_id'] == widget.product_id);
      if (index != -1) {
        cart[index]['quantity']++;
      }
    });
  }

  void _decreaseQuantity() {
    setState(() {
      int index = cart.indexWhere((item) => item['product_id'] == widget.product_id);
      if (index != -1 && cart[index]['quantity'] > 1) {
        cart[index]['quantity']--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 5.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full-Screen Product Image
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                child: widget.image.isNotEmpty
                    ? Image.network(
                  widget.image,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 40, color: Colors.red),
                )
                    : const Icon(Icons.business, size: 100, color: Colors.teal),
              ),
              const SizedBox(height: 20),

              // Product Name
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Product Price
              Text(
                "₹${widget.price}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                ),
              ),
             /* const SizedBox(height: 16),

              // Product Description in a card-like box with padding
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  widget.description,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.justify,
                ),
              ),*/
              const SizedBox(height: 24),

              // Add to Cart Button or Quantity Selector
              _isInCart()
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: _decreaseQuantity,
                    iconSize: 36,
                    color: Colors.teal,
                  ),
                  Text(
                    '${cart.firstWhere((item) => item['product_id'] == widget.product_id)['quantity']}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: _increaseQuantity,
                    iconSize: 36,
                    color: Colors.teal,
                  ),
                ],
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: Size(double.infinity, 50),
                    elevation: 5.0,
                  ),
                  onPressed: _addToCart,
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
