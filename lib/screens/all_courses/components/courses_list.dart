import 'dart:math';

import 'package:flutter/material.dart';

import '../../../widgets/course_info.dart';

class CourseListView extends StatelessWidget {
  final List<Map<String, dynamic>> allCourses;

  CourseListView({super.key, required this.allCourses});

  Color _generateRandomLightColor() {
    final random = Random();
    // Generate random RGB values between 200 and 255 to ensure the color is light
    final red = random.nextInt(56) + 200; // RGB values from 200 to 255
    final green = random.nextInt(56) + 200;
    final blue = random.nextInt(56) + 200;
    return Color.fromRGBO(red, green, blue, 1); // Generate a color
  }

  @override
  Widget build(BuildContext context) {
    // Sort the courses by major
    List<Map<String, dynamic>> sortedCourses = List.from(allCourses)..sort((a, b) => (a['major'] ?? '').compareTo(b['major'] ?? ''));

    // Group courses by major
    Map<String, List<Map<String, dynamic>>> coursesByMajor = {};
    for (var course in sortedCourses) {
      final major = course['major'] ?? 'Unknown';
      if (!coursesByMajor.containsKey(major)) {
        coursesByMajor[major] = [];
      }
      coursesByMajor[major]!.add(course);
    }

    return Expanded(
      child: ListView.builder(
        itemCount: coursesByMajor.length,
        itemBuilder: (context, majorIndex) {
          // Get the major name
          final major = coursesByMajor.keys.elementAt(majorIndex);
          final coursesInMajor = coursesByMajor[major]!;

          // Select background color for the current major
          final backgroundColor = _generateRandomLightColor();

          return Container(
            color: backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Major header
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    major,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // List of courses under this major
                ListView.builder(
                  shrinkWrap: true, // To avoid overflow
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: coursesInMajor.length,
                  itemBuilder: (context, courseIndex) {
                    final course = coursesInMajor[courseIndex];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      elevation: 4,
                      child: ListTile(
                        title: Text(course['name'], style: const TextStyle(fontSize: 18)),
                        subtitle: Text(course['instructor'] ?? 'Instructor not available'),
                        onTap: () => showCourseDetailsDialog(context, course, actionType: 'course_list'),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
