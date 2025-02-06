import 'package:flutter/material.dart';
import 'package:study_buddy/services/course_service.dart';

import 'components/courses_list.dart';
import 'package:study_buddy/view/upload_courses_to_db.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  final CourseService _courseService = CourseService();
  List<Map<String, dynamic>> _allCourses = [];

  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();

    _searchController.addListener(_filterCourses);
  }

  Future<void> _loadCourses() async {
    final courses = await _courseService.fetchAllCourses();
    setState(() {
      _allCourses = courses;
      _filteredCourses = courses;
    });
  }

  void _filterCourses() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCourses = _allCourses
          .where((course) => (course["name"]?.toLowerCase().contains(query) ?? false) || (course["major"]?.toLowerCase().contains(query) ?? false) || (course["instructor"]?.toLowerCase().contains(query) ?? false) || query.isEmpty)
          .toList();
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
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: CourseListView(
                allCourses: _filteredCourses,
              ),
            ),
            const SizedBox(height: 20),
            UploadCoursesButton()
          ],
        ),
      ),
    );
  }
}
