import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Widget _title() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       const Icon(Icons.school, color: Colors.blueAccent, size: 32),
//       const SizedBox(width: 8),
//       ShaderMask(
//         shaderCallback: (bounds) => const LinearGradient(
//           colors: [Colors.blueAccent, Colors.purpleAccent, Colors.pinkAccent],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ).createShader(bounds),
//         child: const Text(
//           'Study Buddy!!',
//           style: TextStyle(
//             fontFamily: 'Roboto', // Built-in system font
//             fontSize: 35,
//             fontWeight: FontWeight.bold,
//             color: Colors.purpleAccent,
//           ),
//         ),
//       ),
//     ],
//   );
// }

Widget _title() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Icon(Icons.school, color: Colors.purpleAccent, size: 32),
      SizedBox(width: 15),
      Text(
        'Study Buddy',
        style: GoogleFonts.modak(
          // Use Google Fonts here
          fontSize: 50,
          // fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: Colors.deepPurpleAccent,
          shadows: [
            Shadow(
              offset: Offset(3, 3),
              blurRadius: 4,
              color: Colors.blue.withOpacity(0.5),
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
