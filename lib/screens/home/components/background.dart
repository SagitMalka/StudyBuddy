import 'package:flutter/material.dart';

class BackgroundWithImages extends StatelessWidget {
  const BackgroundWithImages({Key? key}) : super(key: key);

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
          decoration: BoxDecoration(
            color: Color.fromARGB(150, 226, 223, 209),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 6 - 200,
          left: (MediaQuery.of(context).size.width / 2) - 200,
          child: Image.asset(
            'assets/images/student_hat.png',
            width: 400,
            height: 400,
          ),
        ),
      ],
    );
  }
}
