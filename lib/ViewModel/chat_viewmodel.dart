import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_buddy/Model/services/chat_repository.dart';

class ChatViewModel {
  final ChatRepository _chatRepository;
  final TextEditingController messageController = TextEditingController();
  final StreamController<List<Map<String, dynamic>>> _messagesController = StreamController.broadcast();
  User? get currentUser => FirebaseAuth.instance.currentUser;

  ChatViewModel(this._chatRepository);

  // Public messages stream
  Stream<List<Map<String, dynamic>>> get messagesStream => _messagesController.stream;

  // Fetch and listen to messages
  void listenToMessages(String requestId) {
    _chatRepository.getChatMessages(requestId).listen((snapshot) {
      final messages = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      _messagesController.add(messages);
    });
  }

  // Send a new message
  Future<void> sendMessage(String requestId) async {
    if (messageController.text.trim().isEmpty) return;
    await _chatRepository.sendMessage(requestId, messageController.text, currentUser!.email ?? "Unknown");
    messageController.clear();
  }

  void dispose() {
    _messagesController.close();
  }
}
