import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'package:study_buddy/View/screens/login_register_page.dart';
import 'package:study_buddy/View/screens/home/home_screen.dart';
import 'package:study_buddy/View/screens/all_courses/all_courses_screen.dart';
import 'package:study_buddy/View/screens/profile/profile_screen.dart';
import 'package:study_buddy/widget_tree.dart';
import 'package:study_buddy/View/screens/user_courses/user_courses_screen.dart';
import 'package:study_buddy/firebase_messaging_service.dart';
import 'View/screens/course_forum/course_forum_screen.dart';
//import 'screens/course_forum/course_chat_forum.dart';
import 'View/chat_screen.dart';

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
        '/profile': (context) => const ProfilePage(),
        '/my_courses': (context) => const MyCoursesPage(),
        '/course_forum': (context) => CourseForumScreen(
            courseId: ModalRoute.of(context)!.settings.arguments as String),
        '/chat': (context) => ChatScreen(
            requestId: ModalRoute.of(context)!.settings.arguments as String),
      },
    );
  }
}
