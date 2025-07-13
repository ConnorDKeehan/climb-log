import 'package:climasys/climasys/models/menu_item.dart';
import 'package:flutter/material.dart';


class Menu extends StatelessWidget {
  final bool isGymAdmin;
  final bool isUserLoggedIn;
  final List<MenuItem> menuItems;
  final String menuName;
  const Menu({super.key, required this.isGymAdmin, required this.isUserLoggedIn, required this.menuItems, required this.menuName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(menuName),
      ),
      body: ListView(
        children: menuItems
            .where((menuItem) =>
        (isGymAdmin || !menuItem.adminOnly)
            && (isUserLoggedIn || menuItem.allowAnonymous)
        ).map((menuItem) {
          return ListTile(
            leading: menuItem.icon,
            title: Text(menuItem.text),
            onTap: () {
              //if there is a pre redirect function given, call it
              menuItem.preRedirectFunction?.call();

              // Navigate to the corresponding screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => menuItem.destination),
              );
            },
          );
        }).toList(), // Ensure .toList() is properly closed
      ),
    );
  }
}
