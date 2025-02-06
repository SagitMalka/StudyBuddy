import 'package:flutter/material.dart';
import 'package:study_buddy/view/services/course_service.dart';
import 'package:study_buddy/view/services/user_service.dart';

class UploadCoursesButton extends StatelessWidget {
  final CourseService _courseService = CourseService();

  UploadCoursesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: UserService().isAdmin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasData && snapshot.data == true) {
          return ElevatedButton(
            onPressed: () async {
              await _courseService.loadCoursesToFirebase();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Courses added!")),
                );
              }
            },
            child: const Text("Upload Courses"),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
