import 'package:flutter/material.dart';
import 'package:study_buddy/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseForumScreen extends StatefulWidget {
  final String courseId;
  const CourseForumScreen({super.key, required this.courseId});

  _CourseForumScreenState createState() => _CourseForumScreenState();
}

class _CourseForumScreenState extends State<CourseForumScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  final TextEditingController _requestNameController = TextEditingController();
  final TextEditingController _maxUsersController = TextEditingController();
  final TextEditingController _requestDetailsController = TextEditingController();

  // Method to fetch existing requests for the course
  Future<List<Map<String, dynamic>>> _fetchRequests() async {
    final snapshot = await _firestore.collection('course_requests').where('courseId', isEqualTo: widget.courseId).get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  // Method to create a new request
  Future<void> _createRequest() async {
    final user = _userService.getCurrentUser();
    final requestName = _requestNameController.text;
    final maxUsers = int.tryParse(_maxUsersController.text) ?? 5;
    final details = _requestDetailsController.text;

    if (user != null && requestName.isNotEmpty && details.isNotEmpty) {
      await _firestore.collection('course_requests').add({
        'courseId': widget.courseId,
        'creatorId': user.uid,
        'requestName': requestName,
        'details': details,
        'users': [user.uid],
        'numOfUsers': maxUsers,
      });
      setState(() {});
      _requestNameController.clear();
      _maxUsersController.clear();
      _requestDetailsController.clear();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your request has been created!')),
        );
      }
      Navigator.of(context).pop(); // Close the popup after submission
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly.')),
      );
    }
  }

  void _showCreateRequestDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Learning Group'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _requestNameController,
                  decoration: const InputDecoration(
                    labelText: 'Group Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _maxUsersController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Max Number of Users',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _requestDetailsController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Details',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _createRequest,
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  // Method to join an existing request
  Future<void> _joinRequest(String requestId) async {
    final user = _userService.getCurrentUser();
    if (user != null) {
      await _firestore.collection('course_requests').doc(requestId).update({
        'status': 'joined',
        'users': FieldValue.arrayUnion([user.uid]),
      });
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have joined the group!')),
      );
    }
  }

  // Method to leave an existing request
  Future<void> _leaveRequest(String requestId) async {
    final user = _userService.getCurrentUser();
    if (user != null) {
      await _firestore.collection('course_requests').doc(requestId).update({
        'status': 'joined',
        'users': FieldValue.arrayRemove([user.uid]),
      });
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have left the group!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _userService.getCurrentUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Forum'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
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
            return const Center(child: Text('No groups available.'));
          }
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final requestId = request['id'] ?? '';
              final requestName = request['requestName'] ?? 'Unnamed Request';
              final details = request['details'] ?? 'No details provided.';
              final users = request['users'] ?? [];
              final numOfUsers = request['numOfUsers'] ?? 0;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/chat',
                      arguments: requestId,
                    );
                  },
                  child: ListTile(
                    title: Text('$requestName: ${users.length}/$numOfUsers Users'),
                    subtitle: Text(details),
                    trailing: users.length < numOfUsers
                        ? (!users.contains(user?.uid)
                            ? ElevatedButton(
                                onPressed: () => _joinRequest(requestId),
                                child: const Text('Join'),
                              )
                            : ElevatedButton(
                      onPressed: () => _leaveRequest(requestId),
                      child: const Text('Leave'),
                    )
                    )
                        : Text("full"),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateRequestDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
