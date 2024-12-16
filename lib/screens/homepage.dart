import 'package:Youthpreneur_Hub/screens/cartsection.dart';
import 'package:Youthpreneur_Hub/screens/service_screen.dart';
import 'package:Youthpreneur_Hub/screens/workshop_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Youthpreneur_Hub/screens/signinpage.dart';
import 'package:Youthpreneur_Hub/navigation bar/homesection.dart';
import 'package:Youthpreneur_Hub/navigation bar/profilesection.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userEmail;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchUserEmail();
  }

  // Fetch user email from SharedPreferences
  Future<void> fetchUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('user_email');
    });
  }

  // Log out and clear session
  Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut(); // Supabase logout

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clear locally stored data

      // Navigate to SignInPage
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging out: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Update selected index for bottom navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Youthpreneur Hub!'),

        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*Text(
              'Hello, ${userEmail ?? "User"}!',
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),*/

            // Display selected section based on navigation bar
            Expanded(
              child: _getSelectedPage(_selectedIndex),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake),
            label: 'Service',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_sharp),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_history_outlined),
            label: 'Workshop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  // Returns the appropriate widget based on the selected index
  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return HomeSectionPage();
      case 1:
        return ServicesPage();
      case 2:
        return CartScreen();
      case 3:
        return WorkShopPage();
        case 4:
        return ProfileSectionPage();
      default:
        return HomeSectionPage();
    }
  }
}
