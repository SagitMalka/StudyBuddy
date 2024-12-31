import 'package:flutter/material.dart';
import 'package:study_buddy/services/user_service.dart';
import 'package:study_buddy/widgets/course_info.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  final UserService _userService = UserService();
  List<Map<String, dynamic>> _myCourses = [];

  @override
  void initState() {
    super.initState();
    _loadUserCourses();
  }

  Future<void> _loadUserCourses() async {
    final courses = await _userService.fetchUserCourses();
    setState(() {
      _myCourses = courses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
      ),
      body: ListView.builder(
        itemCount: _myCourses.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_myCourses[index]['name']),
            onTap: () => Navigator.pushNamed(
              context,
              '/course_forum',
              arguments: _myCourses[index]['id'],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.info),
              onPressed: () => showCourseDetailsDialog(context, _myCourses[index], actionType: 'user_courses'),
            ),
          );
        },
      ),
    );
  }
}
