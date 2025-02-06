import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String requestId, String message, String? email, String? uid) async {
    if (message.isNotEmpty && email != null && uid != null) {
      await _firestore.collection('course_requests').doc(requestId).collection('chat').add({
        'text': message,
        'sender': email,
        'user_id': uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<QuerySnapshot> getMessagesStream(String requestId) {
    return _firestore.collection('course_requests').doc(requestId).collection('chat').orderBy('timestamp', descending: true).snapshots();
  }
}
