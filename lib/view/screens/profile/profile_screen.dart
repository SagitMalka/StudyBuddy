import 'package:flutter/material.dart';
import 'package:study_buddy/ViewModel/profile_viewmodel.dart';
import 'package:study_buddy/Model/services/user_service.dart';
import 'package:study_buddy/auth.dart';
import 'components/profile_photo.dart';
import 'components/user_info.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel(UserService(), Auth());
    setState(() {}); // Update UI after initializing ViewModel
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile!')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfilePhoto(user: _viewModel.user),
              const SizedBox(height: 16),
              UserDetails(user: _viewModel.user),
              const SizedBox(height: 24),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await _viewModel.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                  child: const Text('Sign Out!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
