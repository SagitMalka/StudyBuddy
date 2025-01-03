import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  Widget _title() {
    return const Text('Study Buddy');
  }

  Widget _navigateToCoursesButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/courses');
      },
      child: const Text('View Courses'),
    );
  }

  Widget _navigateToMyCoursesButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/my_courses');
      },
      child: const Text('My Courses'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage:
                  user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
              child: user?.photoURL == null ? const Icon(Icons.person) : null,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _navigateToMyCoursesButton(context),
            _navigateToCoursesButton(context),
          ],
        ),
      ),
    );
  }
}
