import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_buddy/Model/services/user_service.dart';

class ProfilePhotoViewModel extends ChangeNotifier {
  final UserService _userService;
  File? _imageFile;
  bool _isSaving = false;

  ProfilePhotoViewModel(this._userService);

  File? get imageFile => _imageFile;
  bool get isSaving => _isSaving;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
      await saveImagePath(pickedFile.path);
    }
  }

  Future<void> saveImagePath(String imagePath) async {
    _isSaving = true;
    notifyListeners();

    try {
      await _userService.updateUserPhoto(imagePath);
    } catch (e) {
      debugPrint('Failed to save image path: $e');
    }

    _isSaving = false;
    notifyListeners();
  }
}
