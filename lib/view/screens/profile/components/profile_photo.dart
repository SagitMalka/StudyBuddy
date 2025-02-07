import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/ViewModel/profile_photo_viewmodel.dart';
import 'package:study_buddy/Model/services/user_service.dart';

class ProfilePhoto extends StatefulWidget {
  final User? user;
  final double size;

  const ProfilePhoto({super.key, required this.user, this.size = 50.0});

  @override
  _ProfilePhotoState createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  late final ProfilePhotoViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfilePhotoViewModel(UserService());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _viewModel.pickImage,
      child: AnimatedBuilder(
        animation: Listenable.merge([_viewModel]),
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: widget.size,
                backgroundImage: _viewModel.imageFile != null ? FileImage(_viewModel.imageFile!) : (widget.user?.photoURL != null ? FileImage(File(widget.user!.photoURL!)) : null),
                child: _viewModel.imageFile == null && widget.user?.photoURL == null ? const Icon(Icons.camera_alt, size: 50) : null,
              ),
              if (_viewModel.isSaving) const CircularProgressIndicator(),
            ],
          );
        },
      ),
    );
  }
}
