import 'package:cloud_firestore/cloud_firestore.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchAllCourses() async {
    final snapshot = await _firestore.collection('courses').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
