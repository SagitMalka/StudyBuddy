import 'package:flutter/material.dart';
import 'package:study_buddy/ViewModel/chat_viewmodel.dart';
import 'package:study_buddy/view/services/chat_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_buddy/view/screens/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String requestId;
  ChatScreen({Key? key, required this.requestId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ChatViewModel(ChatRepository());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _viewModel.getMessagesStream(widget.requestId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;
                List<MessageBubble> messageWidgets = messages.map((message) {
                  final messageText = message['text'];
                  final messageSender = message['sender'];
                  return MessageBubble(
                    sender: messageSender,
                    text: messageText,
                    isMe: _viewModel.currentUser?.email == messageSender,
                  );
                }).toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: messageWidgets.length,
                  itemBuilder: (context, index) => messageWidgets[index],
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _viewModel.messageController,
              decoration: const InputDecoration(hintText: 'Enter your message...'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _viewModel.sendMessage(widget.requestId),
          )
        ],
      ),
    );
  }
}
