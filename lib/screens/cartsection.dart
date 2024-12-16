import 'package:Youthpreneur_Hub/datamodel/order_data_model.dart';
import 'package:flutter/material.dart';
import 'package:Youthpreneur_Hub/datamodel/cart_data_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double _totalPrice = 0.0;
  late String email;
  bool _isCOD = false; // Move this to the state class
  bool cart = false;
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

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

  void _calculateTotal(List<CartDataModel> cartItems) {
    _totalPrice = cartItems.fold(0, (sum, item) => sum + (item.price ?? 0));
  }

  void _showOrderDialog(BuildContext context) {
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _phoneController = TextEditingController();
    final _addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Use StatefulBuilder to update local dialog state
            return AlertDialog(
              title: const Text('Order Details'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cash on Delivery',
                          style: TextStyle(fontSize: 16),
                        ),
                        Checkbox(
                          value: _isCOD,
                          onChanged: (value) {
                            setDialogState(() {
                              _isCOD = value ?? false; // Update local state
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.isEmpty ||
                        _emailController.text.isEmpty ||
                        _phoneController.text.isEmpty ||
                        _addressController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all the fields!')),
                      );
                      return; // Exit early if validation fails
                    }

                    // Fetch cart items and validate
                    final cartItems = await CartDataModel.fetchCartItems(email).first;
                    if (cartItems.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Your cart is empty!')),
                      );
                      return;
                    }

                    // Place orders for each cart item
                    for (final item in cartItems) {
                      final newOrder = OrderDataModel(
                        customer_name: _nameController.text,
                        customer_email: _emailController.text,
                        phone_no: _phoneController.text,
                        product_name: item.product_name,
                        quantity: 1,
                        price: item.price.toString(),
                        address: _addressController.text,
                        mode: _isCOD ? "COD" : "Online",
                        business_name: item.business_name,
                      );

                      await OrderDataModel.createOrder(newOrder);
                      await CartDataModel.removeFromCart(item.product_id!);
                    }
                     setState(() {
                      cart=false;
                    });

                    Navigator.of(context).pop(); // Close the dialog after order placement
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order placed successfully!')),
                    );

                    // Refresh UI to reflect changes
                  },
                  child: const Text('Confirm Order'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cart Section",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<CartDataModel>>(
          stream: CartDataModel.fetchCartItems(email),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'Your cart is empty!',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              );
            }

            final cartItems = snapshot.data!;
            _calculateTotal(cartItems);

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: item.image != null
                                ? Image.network(
                                    item.image!,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.broken_image),
                                  )
                                : const Icon(Icons.shopping_cart),
                          ),
                          title: Text(
                            item.product_name ?? 'Unknown Product',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '₹${item.price}',
                            style: const TextStyle(fontSize: 14, color: Colors.green),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () async {
                              await CartDataModel.removeFromCart(item.product_id!);
                              setState(() {
                                cart=true;
                              }); // Refresh the cart
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total (Exclusive of Delivery Charges):',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹${_totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          _showOrderDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Place Order',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
