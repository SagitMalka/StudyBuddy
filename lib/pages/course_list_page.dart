import 'package:flutter/material.dart';

class CourseListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final courses = [
      {'name': 'Introduction to Programming', 'major': 'Computer Science'},
      {'name': 'Data Structures', 'major': 'Computer Science'},
      {'name': 'Circuit Analysis', 'major': 'Electrical Engineering'},
      {'name': 'Digital Signal Processing', 'major': 'Electrical Engineering'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Courses by Major'),
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return ListTile(
            title: Text(course['name']!),
            subtitle: Text(course['major']!),
          );
        },
      ),
    );
  }
}
