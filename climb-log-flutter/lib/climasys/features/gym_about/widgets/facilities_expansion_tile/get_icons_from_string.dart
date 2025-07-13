import 'package:flutter/material.dart';

IconData getIconDataFromString(String? iconString) {
  switch (iconString?.toLowerCase()) {
    case 'shower':
      return Icons.shower;
    case 'restaurant':
      return Icons.restaurant;
    case 'blur_linear':
      return Icons.blur_linear;
    case 'fitness_center':
      return Icons.fitness_center;
    case 'favorite':
      return Icons.favorite;
    case 'moon':
      return Icons.shield_moon_outlined;
    case 'coffee':
      return Icons.coffee;
    default:
      return Icons.info_outline;
  }
}