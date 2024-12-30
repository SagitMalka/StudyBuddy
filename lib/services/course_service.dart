import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchAllCourses() async {
    final snapshot = await _firestore.collection('courses').get();
    return snapshot.docs.map((doc) {
      var data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  // Load courses from JSON file into Firestore
  Future<void> loadCoursesToFirebase() async {
    try {
      // Load the JSON file from assets
      final String response = await rootBundle.loadString('assets/DB/courses.json');

      final List<dynamic> courses = json.decode(response);

      for (final course in courses) {
        // Check if the course already exists
        final QuerySnapshot existingCourse = await _firestore.collection('courses').where('name', isEqualTo: course['name']).get();

        if (existingCourse.docs.isEmpty) {
          // If course does not exist, add it to Firestore
          await _firestore.collection('courses').add({
            'name': course['name'],
            'major': course['major'],
            'description': course['description'],
            'schedule': course['schedule'],
            'instructor': course['instructor'],
          });
        } else {
          // If course exists, update it (overwrite the existing document)
          final courseDoc = existingCourse.docs.first;
          await _firestore.collection('courses').doc(courseDoc.id).update({
            'name': course['name'],
            'major': course['major'],
            'description': course['description'],
            'schedule': course['schedule'],
            'instructor': course['instructor'],
          });
        }
      }
    } catch (e) {
      print("Error loading courses to Firebase: $e");
    }
  }
}
