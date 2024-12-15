import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase SDK
import 'package:Youthpreneur_Hub/screens/signinpage.dart';
import 'package:Youthpreneur_Hub/screens/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Supabase
    await Supabase.initialize(
      url: 'https://uwoxzdqhgitxjadcmmmr.supabase.co', // Your Supabase URL
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV3b3h6ZHFoZ2l0eGphZGNtbW1yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM4NDk3OTUsImV4cCI6MjA0OTQyNTc5NX0.yIj3_vl2jzQ1lehwWStKQ8_RWiWWBVEfdSDkjUzYu4I', // Your Supabase anonymous key
    );
    runApp(const MyApp());
  } catch (e) {
    print('Supabase initialization failed: $e');
    runApp(const MyApp()); // Proceed even if initialization fails
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Youthpreneur Hub',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    try {
      print('Checking authentication...');

      // Retrieve Supabase session
      final session = Supabase.instance.client.auth.currentSession;
      print('Session: $session');

      // Delay navigation until the widget tree is built
      Future.delayed(Duration.zero, () {
        if (session != null && session.user != null) {
          print('User is authenticated. Redirecting to HomePage.');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          print('User is not authenticated. Redirecting to SignInPage.');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
          );
        }
      });
    } catch (e) {
      print('Error during authentication check: $e');
      // Optionally, you can show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Loading indicator while checking authentication
      ),
    );
  }
}
