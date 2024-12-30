import 'package:flutter/material.dart';
import 'package:status_alert/status_alert.dart';
import 'package:study_buddy/services/user_service.dart';

void showCourseDetailsDialog(BuildContext context, Map<String, dynamic> course) {
  final UserService userService = UserService();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          course['name'],
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Course Major: ${course['major']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'By: ${course['instructor']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Schedule: ${course['schedule']}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Description: ${course['description']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await userService.addCourseToUser(course['name']);

              final truncatedName = course['name'].length > 25 ? '${course['name'].substring(0, 25)}...' : course['name'];

              if (context.mounted) {
                StatusAlert.show(
                  context,
                  duration: const Duration(seconds: 2),
                  title: 'Success',
                  subtitle: '$truncatedName\nadded to your Courses!',
                  configuration: const IconConfiguration(icon: Icons.check_circle, color: Colors.green),
                  backgroundColor: Colors.green[50],
                );
              }
            },
            child: const Text('Add To My Courses'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
