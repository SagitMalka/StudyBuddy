import 'package:flutter/material.dart';
import 'package:study_buddy/services/course_service.dart';
import 'package:study_buddy/services/user_service.dart';
import 'package:status_alert/status_alert.dart';
import 'dart:convert';
import 'package:flutter/services.dart'; // To read the assets

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
    _loadCourses(); // Initially load courses
  }

  // Function to load courses from the JSON file
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Button to load new courses from the JSON
            ElevatedButton(
              onPressed: () async {
                await _courseService.loadCoursesToFirebase();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Courses loaded to Firebase!")),
                  );
                }
              },
              child: const Text("Add Courses to Firebase"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _allCourses.length,
                itemBuilder: (context, index) {
                  final course = _allCourses[index];
                  return ListTile(
                    title: Text(course['name']),
                    subtitle: Text(course['major'] ?? 'No major specified'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        await _userService.addCourseToUser(course['name']);

                        final truncatedName = course['name'].length > 25
                            ? '${course['name'].substring(0, 25)}...'
                            : course['name'];

                        if (context.mounted) {
                          StatusAlert.show(
                            context,
                            duration: const Duration(seconds: 2),
                            title: 'Success',
                            subtitle: '$truncatedName\nadded to your Courses!',
                            configuration: const IconConfiguration(
                                icon: Icons.check_circle, color: Colors.green),
                            backgroundColor: Colors.green[50],
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
