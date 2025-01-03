// lib/widgets/upload_courses_button.dart

import 'package:flutter/material.dart';
import 'package:study_buddy/services/course_service.dart';

class UploadCoursesButton extends StatelessWidget {
  final CourseService _courseService = CourseService();

  UploadCoursesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await _courseService.loadCoursesToFirebase();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Courses loaded to Firebase!")),
          );
        }
      },
      child: const Text("Upload Courses To Firebase"),
    );
  }
}
