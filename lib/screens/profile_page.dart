import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_buddy/auth.dart';

import '../services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();
  User? _user;
  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _signOut(BuildContext context) async {
    await Auth().signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _getUser() async {
    final user = _userService.getCurrentUser();
    setState(() {
      _user = user;
    });
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
                backgroundImage: _user?.photoURL != null ? NetworkImage(_user!.photoURL!) : null, // Display photo if available
                child: _user?.photoURL == null
                    ? const Icon(Icons.person, size: 50) // Default icon
                    : null,
              ),
              const SizedBox(height: 16),
              // User Name
              Text(
                _user?.displayName ?? 'No Name',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Email Address
              Text(
                _user?.email ?? 'No Email',
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
