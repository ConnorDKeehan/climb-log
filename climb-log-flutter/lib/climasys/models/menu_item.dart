import 'package:flutter/material.dart';

class MenuItem {
  final Icon icon;
  final String text;
  final Function? preRedirectFunction;
  final Widget destination;
  final bool adminOnly;
  final bool allowAnonymous;

  MenuItem({
    required this.icon,
    required this.text,
    required this.destination,
    this.preRedirectFunction,
    this.adminOnly = false,
    this.allowAnonymous = false
  });
}