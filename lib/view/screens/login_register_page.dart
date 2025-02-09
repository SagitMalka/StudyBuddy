import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth.dart';
import '../../Model/services/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMassage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMassage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword(BuildContext context) async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMassage = e.message;
      });
    }

    UserService().updateUserInfo(_controllerName.text, _controllerEmail.text);
  }

  Widget _title() {
    return const Text('Study Buddy');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMassage == '' ? '' : 'Humm ? $errorMassage');
  }

  Widget _submitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isLogin
          ? () => signInWithEmailAndPassword(context)
          : () => createUserWithEmailAndPassword(context),
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Regiter instead' : 'Login instead'),
    );
  }
  /// **פתיחת חשבון עם Google**
Widget _googleSignInButton(BuildContext context) {
  return ElevatedButton.icon(
    onPressed: () => signInWithGoogle(context),
    icon: Image.asset(
      'assets/images/google_logo.png',
      height: 24,
    ), // Image.asset
    label: const Text("Sign in with Google"),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
  ); // ElevatedButton.icon
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
            _entryField('email', _controllerEmail),
            _entryField('password', _controllerPassword),
            if (!isLogin) _entryField('name', _controllerName),
            _errorMessage(),
            _submitButton(context),
            _loginOrRegisterButton(),
          ],
        ),
      ),
    );
  }
}
