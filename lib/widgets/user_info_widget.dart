import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart'; // Adjust the import path based on your file structure

class UserInfoWidget extends StatelessWidget {
  final User? user = Auth().currentUser;

  Future<void> _signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          user?.email ?? 'User email',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _signOut,
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}
