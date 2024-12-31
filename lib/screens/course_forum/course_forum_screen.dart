import 'package:flutter/material.dart';
import 'package:study_buddy/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseForumScreen extends StatefulWidget {
  final String courseId;
  CourseForumScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  _CourseForumScreenState createState() => _CourseForumScreenState();
}

class _CourseForumScreenState extends State<CourseForumScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  final TextEditingController _requestDetailsController = TextEditingController();

  // Method to fetch existing requests for the course
  Future<List<Map<String, dynamic>>> _fetchRequests() async {
    final snapshot = await _firestore.collection('course_requests').where('courseId', isEqualTo: widget.courseId).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Method to create a new request
  Future<void> _createRequest(String details) async {
    final user = _userService.getCurrentUser();
    if (user != null) {
      await _firestore.collection('course_requests').add({
        'courseId': widget.courseId,
        'userId': user.uid,
        'requestType': 'Create',
        'details': details,
        'status': 'open',
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() {});
      _requestDetailsController.clear();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your request has been created!')));
      }
    }
  }

  // Method to join an existing request
  Future<void> _joinRequest(String requestId) async {
    final user = _userService.getCurrentUser();
    if (user != null) {
      await _firestore.collection('course_requests').doc(requestId).update({
        'status': 'joined', // Change status to joined when the user joins
        'userIds': FieldValue.arrayUnion([user.uid]),
      });
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You have joined the request!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Forum'),
      ),
      body: Column(
        children: [
          // Create request section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _requestDetailsController,
              decoration: const InputDecoration(
                labelText: 'Enter request details',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final details = _requestDetailsController.text;
              if (details.isNotEmpty) {
                _createRequest(details);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter details')));
              }
            },
            child: const Text('Create Learning Group Request'),
          ),

          // Divider
          const Divider(height: 20, color: Colors.grey),

          // Existing requests section
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchRequests(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching requests.'));
                }

                final requests = snapshot.data ?? [];
                if (requests.isEmpty) {
                  return const Center(child: Text('No requests available.'));
                }

                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    final requestId = request['id'];
                    final requestType = request['type'];
                    final details = request['details'];
                    final status = request['status'];
                    final users = request['users'];
                    final numOfUsers = request['numOfUsers'];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(
                          requestType == 'assignment partners' ? 'Assignment partners: ${users.length}/$numOfUsers.' : 'Study group ${users.length}/$numOfUsers.',
                        ),
                        subtitle: Text(details),
                        trailing: status == 'open'
                            ? ElevatedButton(
                                onPressed: () {
                                  _joinRequest(requestId);
                                },
                                child: const Text('Join Request'),
                              )
                            : Text(status),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
