import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch chat messages stream
  Stream<QuerySnapshot> getChatMessages(String requestId) {
    return _firestore.collection('course_requests').doc(requestId).collection('chat').orderBy('timestamp', descending: true).snapshots();
  }

  // Send a message
  Future<void> sendMessage(String requestId, String message, String sender) async {
    await _firestore.collection('course_requests').doc(requestId).collection('chat').add({
      'text': message,
      'sender': sender,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
