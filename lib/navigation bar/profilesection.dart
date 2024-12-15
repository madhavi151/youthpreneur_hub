import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Youthpreneur_Hub/screens/signinpage.dart';

class ProfileSectionPage extends StatefulWidget {

  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSectionPage> {
  late String username;
  late String email;

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
      username = user.userMetadata?['username'] ?? 'No username';
    } else {
      email = 'No email';
      username = 'No username';
    }
    setState(() {});
  }

  Future<void> updateDetails(String newUsername, String newEmail) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;

      await Supabase.instance.client.from('users').upsert({
        'id': userId,
        'username': newUsername,
        'email': newEmail,
      });

      setState(() {
        username = newUsername;
        email = newEmail;
      });
    } catch (e) {
      print('Error updating details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(context),
            const SizedBox(height: 20),

            // Log Out Section
            _buildListTile(
              context,
              icon: Icons.logout,
              title: 'Log Out',
              subtitle: 'Tap to log out from the app.',
              onTap: () {
                Supabase.instance.client.auth.signOut();
                clearUserCredentials();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignInPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> clearUserCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              email,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildListTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        String? subtitle,
        VoidCallback? onTap,
      }) {
    return Card(
      elevation: 5,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.red[50],
          child: Icon(
            icon,
            color: Colors.green,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: subtitle != null
            ? Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        )
            : null,
        trailing:
        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}
