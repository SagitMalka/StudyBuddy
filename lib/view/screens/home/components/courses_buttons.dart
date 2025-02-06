import 'package:flutter/material.dart';

Widget allCoursesButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      Navigator.pushNamed(context, '/courses');
    },
    child: const Text('View All Courses'),
  );
}

Widget myCoursesButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      Navigator.pushNamed(context, '/my_courses');
    },
    child: const Text('My Courses'),
  );
}
