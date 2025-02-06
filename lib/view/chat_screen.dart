import 'package:flutter/material.dart';
import 'package:study_buddy/ViewModel/chat_viewmodel.dart';
import 'package:study_buddy/Model/services/chat_repository.dart';
import 'package:study_buddy/View/screens/course_forum/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String requestId;
  const ChatScreen({Key? key, required this.requestId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ChatViewModel(ChatRepository());
    _viewModel.listenToMessages(widget.requestId);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _viewModel.messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      sender: messages[index]['sender'],
                      text: messages[index]['text'],
                      isMe: _viewModel.currentUser?.email == messages[index]['sender'],
                    );
                  },
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
