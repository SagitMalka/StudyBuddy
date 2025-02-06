import 'package:flutter/material.dart';
import 'package:study_buddy/view/services/user_service.dart';
import 'package:study_buddy/view/widgets/course_info.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  final UserService _userService = UserService();
  List<Map<String, dynamic>> _myCourses = [];
  List<Map<String, dynamic>> _filteredCourses = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserCourses();
    _searchController.addListener(_filterCourses);
  }

  Future<void> _loadUserCourses() async {
    final courses = await _userService.fetchUserCourses();
    setState(() {
      _myCourses = courses;
      _filteredCourses = courses;
    });
  }

  void _filterCourses() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCourses =
          _myCourses.where((course) => (course["name"]?.toLowerCase().contains(query) ?? false) || (course["major"]?.toLowerCase().contains(query) ?? false) || (course["instructor"]?.toLowerCase().contains(query) ?? false) || query.isEmpty).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search my courses...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCourses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_filteredCourses[index]['name']),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/course_forum',
                      arguments: _filteredCourses[index]['id'],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.info),
                      onPressed: () => showCourseDetailsDialog(
                        context,
                        _filteredCourses[index],
                        actionType: 'user_courses',
                      ),
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
