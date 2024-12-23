import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_buddy/auth.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final User? user = Auth().currentUser;

  Future<void> _signOut(BuildContext context) async {
    await Auth().signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Photo
              CircleAvatar(
                radius: 50,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : null, // Display photo if available
                child: user?.photoURL == null
                    ? const Icon(Icons.person, size: 50) // Default icon
                    : null,
              ),
              const SizedBox(height: 16),
              // User Name
              Text(
                user?.displayName ?? 'No Name',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Email Address
              Text(
                user?.email ?? 'No Email',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              // Sign-Out Button
              ElevatedButton(
                onPressed: () => _signOut(context),
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
