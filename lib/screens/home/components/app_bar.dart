import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget _title() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(Icons.school, color: Colors.blueAccent, size: 32),
      const SizedBox(width: 8),
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Colors.blueAccent, Colors.purpleAccent, Colors.pinkAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: const Text(
          'Study Buddy!!',
          style: TextStyle(
            fontFamily: 'Roboto', // Built-in system font
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.purpleAccent,
          ),
        ),
      ),
    ],
  );
}

AppBar buildAppBar(photoURL, BuildContext context) {
  return AppBar(
    title: _title(),
    actions: [
      IconButton(
        icon: CircleAvatar(
          backgroundImage: photoURL != null ? NetworkImage(photoURL!) : null,
          child: photoURL == null ? const Icon(Icons.person) : null,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/profile');
        },
      ),
    ],
  );
}
