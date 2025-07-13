import 'package:climasys/climasys/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'main_menu_items.dart';

class MainMenu extends StatelessWidget {
  final bool isGymAdmin;
  final bool isUserLoggedIn;
  const MainMenu({super.key, required this.isGymAdmin, required this.isUserLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Menu(isGymAdmin: isGymAdmin, isUserLoggedIn: isUserLoggedIn, menuItems: mainMenuItems, menuName: "Menu");
  }
}
