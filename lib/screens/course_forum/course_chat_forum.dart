// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:study_buddy/services/user_service.dart';

// class ChatScreen extends StatefulWidget {
//   final String requestId;
//   ChatScreen({Key? key, required this.requestId}) : super(key: key);

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final UserService _userService = UserService();
//   final TextEditingController _messageController = TextEditingController();

//   void sendMessage() async {
//     final user = _userService.getCurrentUser();
//     if (_messageController.text.isNotEmpty) {
//       await _firestore
//           .collection('course_requests')
//           .doc(widget.requestId)
//           .collection('chat')
//           .add({
//         'text': _messageController.text,
//         'sender': user?.email,
//         'user_id': user?.uid,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//       _messageController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Group Chat'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firestore
//                   .collection('course_requests')
//                   .doc(widget.requestId)
//                   .collection('chat')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//                 final messages = snapshot.data!.docs;
//                 List<MessageBubble> messageWidgets = [];
//                 for (var message in messages) {
//                   final messageText = message['text'];
//                   final messageSender = message['sender'];

//                   final messageWidget = MessageBubble(
//                     sender: messageSender,
//                     text: messageText,
//                     isMe: _userService.getCurrentUser()?.email == messageSender,
//                   );
//                   messageWidgets.add(messageWidget);
//                 }
//                 return ListView(
//                   reverse: true,
//                   children: messageWidgets,
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: const InputDecoration(
//                       hintText: 'Enter your message...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: sendMessage,
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MessageBubble extends StatelessWidget {
//   final String sender;
//   final String text;
//   final bool isMe;

//   MessageBubble({required this.sender, required this.text, required this.isMe});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment:
//             isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Text(
//             sender,
//             style: const TextStyle(fontSize: 12, color: Colors.black54),
//           ),
//           Material(
//             borderRadius: BorderRadius.circular(30.0),
//             color: isMe ? Colors.blueAccent : Colors.grey[300],
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               child: Text(
//                 text,
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: isMe ? Colors.white : Colors.black54,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
