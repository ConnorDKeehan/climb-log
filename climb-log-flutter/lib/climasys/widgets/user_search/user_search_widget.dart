import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/api/models/login_response.dart';
import 'package:climasys/climasys/widgets/user_search/user_profile_row.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:flutter/material.dart';

class UserSearchWidget extends StatefulWidget {
  const UserSearchWidget({super.key});

  @override
  createState() => _UserSearchWidgetState();
}

class _UserSearchWidgetState extends State<UserSearchWidget> {
  final TextEditingController searchFieldController = TextEditingController();
  List<LoginResponse> users = [];
  bool isLoading = true;
  late String gymName;
  late bool isGymAdmin;

  @override
  void initState() {
    super.initState();
    initWidget();
  }

  void initWidget() async {
    final gymNameResponse = await getGymName(context);
    final isGymAdminResponse = await isUserGymAdmin(gymName: gymNameResponse);

    setState(() {
      isLoading = false;
      gymName = gymNameResponse;
      isGymAdmin = isGymAdminResponse;
    });
  }

  void handleSearch() async {
    try {
      setState(() {
        isLoading = true;
      });

      final usersResponse =
          await searchLoginsByString(gymName, searchFieldController.text);

      setState(() {
        users = usersResponse;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Ensure loading is reset even on failure
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to search :(')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(children: [
              Expanded(
                  flex: 7,
                  child: TextField(
                      controller: searchFieldController,
                      decoration: const InputDecoration(
                        labelText: 'Search username/email/name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ))),
              IconButton(
                  onPressed: handleSearch, icon: const Icon(Icons.search))
            ])),
        if (isLoading) const Center(child: CircularProgressIndicator()),
        if (!isLoading && users.isNotEmpty)
          ...users.map((user) => UserProfileRow(
                user: user,
                gymName: gymName,
                refreshSearch: handleSearch,
                isGymAdmin: isGymAdmin,
              )),
      ],
    );
  }
}
