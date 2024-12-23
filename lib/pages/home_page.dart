import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_buddy/auth.dart';
import 'package:flutter/material.dart';
import 'course_list_page.dart'; 

class HomePage extends StatelessWidget{
  HomePage({super.key});
  final User? user = Auth().currentUser;


  Future<void> signOut() async{
    await Auth().signOut();
  }

  Widget _titel(){
    return const Text('Firebase Auth');
  }  
  Widget _userUid(){
    return Text(user?.email ?? 'user email');
  }
  Widget _signOutButton()  {
    return ElevatedButton(
      onPressed: signOut, 
      child: const Text('Sign Out'),
      );
  }
  Widget _navigateToCoursesButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CourseListPage()),
        );
      },
      child: const Text('View Courses'),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _titel(),
      ), //AppBar
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userUid(),
            _signOutButton(),
            _navigateToCoursesButton(context), // Button to view courses
          ],
        ),
      ),
    );
  }
}