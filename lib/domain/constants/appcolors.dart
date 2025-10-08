import 'package:flutter/material.dart';

class Appcolors {
  static BoxDecoration Backroundgradient() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF7B68EE), // Medium slate blue
          Color(0xFF9370DB), // Medium purple
          Color.fromARGB(255, 110, 79, 184), // Medium orchid
        ],
      ),
    );
  }

  static Color TextColor = Color.fromARGB(255, 115, 101, 193);
}
