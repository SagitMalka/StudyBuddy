import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchUserCourses() async {
    final user = _auth.currentUser;

    if (user != null) {
      // Fetch user courses (the list of course IDs the user is enrolled in)
      final doc = await _firestore.collection('users').doc(user.uid).get();
      List<String> courseIds = List<String>.from(doc['user_courses'] ?? []);

      if (courseIds.isEmpty) {
        return [];
      }

      // Fetch the courses that match the user c47ourse IDs
      final snapshot = await _firestore
          .collection('courses')
          .where(FieldPath.documentId, whereIn: courseIds) // Fetch by course ID
          .get();

      // Return the list of course data, with the document ID included
      return snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id; // Add the course document ID
        return data;
      }).toList();
    }

    return [];
  }

  Future<void> addCourseToUser(String courseName) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final snapshot = await userDoc.get();
      if (snapshot.exists) {
        List<String> courses = List<String>.from(snapshot['user_courses'] ?? []);
        if (!courses.contains(courseName)) {
          courses.add(courseName);
          await userDoc.update({'user_courses': courses});
        }
      } else {
        await userDoc.set({
          'user_courses': [courseName]
        });
      }
    }
  }
}
