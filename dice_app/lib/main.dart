import 'package:flutter/material.dart';
import 'package:dice_app/gradient_container.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: GradientContainer(
          Color.fromARGB(255, 109, 119, 236),
          Color.fromARGB(255, 5, 11, 77),
        ),
      ),
    ),
  );
}
