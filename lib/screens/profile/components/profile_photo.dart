import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_buddy/services/user_service.dart';

class ProfilePhoto extends StatefulWidget {
  final User? user;
  final double size;

  const ProfilePhoto({
    super.key,
    required this.user,
    this.size = 50.0,
  });

  @override
  _ProfilePhotoState createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  File? _imageFile;
  bool _isSaving = false;
  final UserService _userService = UserService();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      await _saveImagePath(pickedFile.path);
    }
  }

  Future<void> _saveImagePath(String imagePath) async {
    if (widget.user == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Save the local image path in Firestore
      await _userService.updateUserPhoto(imagePath);

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile photo path saved successfully!')),
      );
    } catch (e) {
      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save image path: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: widget.size,
            backgroundImage: _imageFile != null
                ? FileImage(_imageFile!)
                : (widget.user?.photoURL != null ? FileImage(File(widget.user!.photoURL!)) : null),
            child: _imageFile == null && widget.user?.photoURL == null
                ? const Icon(Icons.camera_alt, size: 50)
                : null,
          ),
          if (_isSaving)
            const CircularProgressIndicator(),
        ],
      ),
    );
  }
}