import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'package:study_buddy/screens/login_register_page.dart';
import 'package:study_buddy/screens/home_page.dart';
import 'package:study_buddy/screens/all_courses/all_courses_screen.dart';
import 'package:study_buddy/screens/profile_page.dart';
import 'package:study_buddy/widget_tree.dart';
import 'package:study_buddy/screens/user_courses/user_courses_screen.dart';

import 'screens/course_forum/course_forum_screen.dart';

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
        '/courses': (context) => const CourseListPage(),
        '/profile': (context) => ProfilePage(),
        '/my_courses': (context) => const MyCoursesPage(),
        '/course_forum': (context) => CourseForumScreen(courseId: ModalRoute.of(context)!.settings.arguments as String),
      },
    );
  }
}
