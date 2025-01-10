import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatelessWidget {
  final User? user;

  const UserDetails({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          user?.displayName ?? 'No Name',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(user?.email ?? 'No Email', style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        const Text(
          'Phone: +1234567890',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
