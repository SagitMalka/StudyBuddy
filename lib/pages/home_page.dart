import 'package:flutter/material.dart';
import 'package:study_buddy/widgets/user_info_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  Widget _title() {
    return const Text('Study Buddy');
  }

  Widget _navigateToCoursesButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/courses');
      },
      child: const Text('View Courses'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            UserInfoWidget(),
            _navigateToCoursesButton(context),
          ],
        ),
      ),
    );
  }
}
