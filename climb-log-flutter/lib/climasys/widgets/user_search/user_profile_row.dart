import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/api/models/login_response.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserProfileRow extends StatefulWidget {
  final LoginResponse user;
  final String gymName;
  final bool isGymAdmin;
  final VoidCallback refreshSearch;

  const UserProfileRow(
      {super.key,
      required this.user,
      required this.gymName,
      required this.refreshSearch,
      required this.isGymAdmin});

  @override
  State<UserProfileRow> createState() => _UserProfileRowState();
}

class _UserProfileRowState extends State<UserProfileRow> {
  bool isUserBeingChanged = false;

  void _handleAddAdmin(int loginId) async {
    setState(() {
      isUserBeingChanged = true;
    });
    try {
      await addGymAdmin(widget.gymName, loginId);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully Added Admin")));
      widget.refreshSearch();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Failed To Add Admin")));
      setState(() {
        isUserBeingChanged = false;
      });
    }
  }

  void _handleRemoveAdmin(int loginId) async {
    setState(() {
      isUserBeingChanged = true;
    });
    try {
      await removeGymAdmin(widget.gymName, loginId);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully Removed Admin")));
      widget.refreshSearch();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed To Remove Admin")));
      setState(() {
        isUserBeingChanged = false;
      });
    }
  }

  Widget _dropDownButton(bool isUserAdmin, int loginId) {
    return MenuAnchor(
      menuChildren: [
        if (widget.isGymAdmin) ...[
          if (isUserAdmin)
            MenuItemButton(
              onPressed: () {
                _handleRemoveAdmin(loginId);
              },
              child: const Text('Remove Admin'),
            )
          else
            MenuItemButton(
              onPressed: () {
                _handleAddAdmin(loginId);
              },
              child: const Text('Add Admin'),
            ),
        ] else
          const MenuItemButton(child: Text("No options"))
      ],
      builder: (context, controller, child) {
        return IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: ClipOval(
          child: widget.user.profileImageUrl != null
              ? CachedNetworkImage(
                  imageUrl: widget.user.profileImageUrl!,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 40,
                  height: 40,
                  color: Colors.grey[300], // Background color for default icon
                  child: Icon(
                    Icons.account_circle,
                    size: 40,
                    color: Colors.grey[600], // Icon color
                  ),
                ),
        ),
        title: Text(widget.user.displayName),
        trailing: isUserBeingChanged
            ? const CircularProgressIndicator()
            : _dropDownButton(widget.user.isGymAdmin, widget.user.loginId),
      ),
    );
  }
}
