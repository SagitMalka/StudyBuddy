import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/view/services/chat_repository.dart';
import 'package:study_buddy/view/services/user_service.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatRepository _chatRepository;
  final UserService _userService = UserService();
  final TextEditingController messageController = TextEditingController();

  ChatViewModel(this._chatRepository);

  User? get currentUser => _userService.getCurrentUser();

  void sendMessage(String requestId) {
    _chatRepository.sendMessage(
      requestId,
      messageController.text,
      currentUser?.email,
      currentUser?.uid,
    );
    messageController.clear();
  }

  Stream<QuerySnapshot> getMessagesStream(String requestId) {
    return _chatRepository.getMessagesStream(requestId);
  }
}
