import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_buddy/Model/services/user_service.dart';
import 'package:study_buddy/auth.dart';

class ProfileViewModel {
  final UserService _userService;
  final Auth _auth;
  User? _user;

  ProfileViewModel(this._userService, this._auth) {
    _getUser();
  }

  User? get user => _user;

  void _getUser() {
    _user = _userService.getCurrentUser();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
