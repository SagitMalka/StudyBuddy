import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePhoto extends StatelessWidget {
  final User? user;
  final double size;

  const ProfilePhoto({
    super.key,
    required this.user,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null, // Display photo if available
      child: user?.photoURL == null
          ? const Icon(Icons.person, size: 50) // Default icon
          : null,
    );
  }
}
