import 'package:flutter/material.dart';

class BackgroundWithImages extends StatelessWidget {
  const BackgroundWithImages({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          child: Image.asset(
            'assets/images/book_pile.png',
            width: 250,
            height: 250,
          ),
        ),
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromARGB(150, 226, 223, 209),
          ),
        ),
      ],
    );
  }
}
