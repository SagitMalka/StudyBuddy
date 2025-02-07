import 'package:flutter/material.dart';
import 'package:study_buddy/ViewModel/course_list_viewmodel.dart';
import 'package:study_buddy/Model/services/course_service.dart';
import 'components/courses_list.dart';
import 'package:study_buddy/View/upload_courses_to_db.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  late final CourseListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CourseListViewModel(CourseService());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _viewModel.searchController,
              decoration: InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _viewModel.coursesStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  return CourseListView(allCourses: snapshot.data!);
                },
              ),
            ),
            const SizedBox(height: 20),
            UploadCoursesButton(),
          ],
        ),
      ),
    );
  }
}
