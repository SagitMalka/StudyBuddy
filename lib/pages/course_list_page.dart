import 'package:flutter/material.dart';
import 'package:study_buddy/services/course_service.dart';
import 'package:study_buddy/services/user_service.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  final CourseService _courseService = CourseService();
  final UserService _userService = UserService();
  List<Map<String, dynamic>> _allCourses = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    final courses = await _courseService.fetchAllCourses();
    setState(() {
      _allCourses = courses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course List'),
      ),
      body: ListView.builder(
        itemCount: _allCourses.length,
        itemBuilder: (context, index) {
          final course = _allCourses[index];
          return ListTile(
            title: Text(course['name']),
            subtitle: Text(course['major']),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await _userService.addCourseToUser(course['name']);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${course['name']} added to My Courses!')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
