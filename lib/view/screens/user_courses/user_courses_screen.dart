import 'package:flutter/material.dart';
import 'package:study_buddy/ViewModel/user_courses_viewmodel.dart';
import 'package:study_buddy/Model/services/user_service.dart';
import 'package:study_buddy/View/widgets/course_info.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  late MyCoursesViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = MyCoursesViewModel(UserService());
    _loadCourses();
    _searchController.addListener(() {
      setState(() {
        _viewModel.filterCourses(_searchController.text);
      });
    });
  }

  Future<void> _loadCourses() async {
    await _viewModel.loadUserCourses();
    setState(() {}); // Update UI after loading courses
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Courses')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search my courses...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _viewModel.filteredCourses.length,
                itemBuilder: (context, index) {
                  final course = _viewModel.filteredCourses[index];
                  return ListTile(
                    title: Text(course['name']),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/course_forum',
                      arguments: course['id'],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.info),
                      onPressed: () => showCourseDetailsDialog(
                        context,
                        course,
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
