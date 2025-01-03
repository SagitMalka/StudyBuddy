import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    final User? user = _auth.currentUser;
    return user;
  }

  Future<List<Map<String, dynamic>>> fetchUserCourses() async {
    final user = getCurrentUser();

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

  Future<void> removeCourseFromUser(String courseName) async {
    final user = _auth.currentUser;
    if (user != null) {
      // Get the user's document from Firebase
      final doc = await _firestore.collection('users').doc(user.uid).get();

      // Check if the user document exists and contains the user_courses field
      if (doc.exists && doc.data() != null) {
        List<dynamic> userCourses = doc['user_courses'] ?? [];

        // Check if the course exists in the user's courses list
        if (userCourses.contains(courseName)) {
          // Remove the course from the user's courses list
          userCourses.remove(courseName);

          // Update the user's document with the new list
          await _firestore.collection('users').doc(user.uid).update({
            'user_courses': userCourses,
          });

          print('Course removed: $courseName');
        } else {
          print('Course not found in user\'s courses list');
        }
      } else {
        print('User document not found');
      }
    } else {
      print('User not authenticated');
    }
  }

  Future<void> updateUserInfo(String name, String email) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Update the display name in Firebase Authentication
        await user.updateDisplayName(name);

        // Update user info in Firestore under the 'users' collection
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
          {
            'email': email,
            'displayName': name,
            'user_courses': [], // Initialize with an empty list or add default values
          },
          SetOptions(merge: true), // Ensures only the specified fields are updated if the document exists
        );
        print("User info updated successfully");
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      print('Error updating user info: ${e.message}');
    } catch (e) {
      // Handle any other errors
      print('Unexpected error: $e');
    }
  }
}
