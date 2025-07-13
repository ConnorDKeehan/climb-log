import 'package:flutter/material.dart';

Color getColorFromString(String colorString) {
  switch (colorString.toLowerCase()) {
    case 'blue':
      return Colors.blueAccent;
    case 'yellow':
      return Colors.yellow;
    case 'orange':
      return Colors.orange;
    case 'green':
      return Colors.green;
    case 'purple':
      return Colors.purple;
    case 'black':
      return Colors.black;
    case 'red':
      return const Color(0xFFFF0000);
    case 'pink':
      return Colors.pink;
    case 'white':
      return Colors.white;
    case 'teal':
      return Colors.cyanAccent;
    default:
      return Colors.grey; // Default color if unknown
  }
}