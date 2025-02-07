import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget _title() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Icon(Icons.school, color: Colors.purpleAccent, size: 32),
      const SizedBox(width: 15),
      Text(
        'Study Buddy',
        style: GoogleFonts.modak(
          // Use Google Fonts here
          fontSize: 50,
          // fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: const Color.fromARGB(255, 185, 119, 211),
          shadows: [
            Shadow(
              offset: const Offset(3, 3),
              blurRadius: 4,
              color: Colors.blueAccent.withOpacity(0.5),
            ),
          ],
        ),
      ),
    ],
  );
}

AppBar buildAppBar(photoURL, BuildContext context) {
  return AppBar(
    backgroundColor: Color.fromARGB(100, 226, 223, 209),
    title: _title(),
    actions: [
      IconButton(
        icon: CircleAvatar(
          backgroundImage: photoURL != null ? NetworkImage(photoURL!) : null,
          child: photoURL == null ? const Icon(Icons.person) : null,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/profile');
        },
      ),
    ],
  );
}
