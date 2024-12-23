import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Course>> fetchCourses() async {
    final snapshot = await _firestore.collection('courses').get();
    return snapshot.docs.map((doc) {
      return Course.fromMap(doc.data());
    }).toList();
  }
}
