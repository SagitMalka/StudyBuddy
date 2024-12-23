import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'package:study_buddy/pages/login_register_page.dart';
import 'package:study_buddy/pages/home_page.dart';
import 'package:study_buddy/pages/course_list_page.dart';
import 'package:study_buddy/pages/profile_page.dart';
import 'package:study_buddy/widget_tree.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures bindings are initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Buddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WidgetTree(),
        '/home': (context) => HomePage(),
        '/login': (context) => const LoginPage(),
        '/courses': (context) => CourseListPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
