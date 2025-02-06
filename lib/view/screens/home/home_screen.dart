import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_buddy/view/screens/home/components/app_bar.dart';

import 'components/background.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(user?.photoURL, context),
      body: Stack(
        children: [
          const BackgroundWithImages(),
          const SizedBox(
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  user != null ? 'Welcome, ${user!.displayName}!' : 'Welcome to Study Buddy!',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 185, 119, 211),
                    // color: const Color.fromARGB(255, 226, 223, 209),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/my_courses'),
                  child: const Text('My Courses'),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(35),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/courses'),
                  child: const Text('View All Courses'),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(45),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
