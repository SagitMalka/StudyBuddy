import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_buddy/auth.dart';

import '../../../Model/services/user_service.dart';
import 'components/profile_photo.dart';
import 'components/user_info.dart';

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
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
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
        title: const Text('Profile!'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfilePhoto(user: _user),
              const SizedBox(height: 16),
              UserDetails(user: _user),
              const SizedBox(height: 24),
              // Sign-Out Button
              const Spacer(),
              // Sign Out Button at the bottom
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () => _signOut(context),
                  child: const Text('Sign Out!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
