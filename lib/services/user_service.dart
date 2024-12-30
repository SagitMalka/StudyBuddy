import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> fetchUserCourses() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return List<String>.from(doc['user_courses'] ?? []);
    }
    return [];
  }

  Future<void> addCourseToUser(String courseName) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final snapshot = await userDoc.get();
      if (snapshot.exists) {
        List<String> courses =
            List<String>.from(snapshot['user_courses'] ?? []);
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
