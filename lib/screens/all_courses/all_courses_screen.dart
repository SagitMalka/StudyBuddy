import 'package:flutter/material.dart';
import 'package:study_buddy/services/course_service.dart';

import 'components/courses_list.dart';
import 'components/upload_courses_to_db.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  final CourseService _courseService = CourseService();
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CourseListView(
              allCourses: _allCourses,
            ),
            const SizedBox(height: 20),
            UploadCoursesButton()
          ],
        ),
      ),
    );
  }
}
