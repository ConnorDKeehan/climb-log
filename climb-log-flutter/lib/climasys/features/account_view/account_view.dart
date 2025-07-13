import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/features/account_view/account_view_api.dart';
import 'package:climasys/climasys/features/account_view/models/get_account_details_query_response.dart';
import 'package:climasys/climasys/features/account_view/widgets/confirm_delete_dialog.dart';
import 'package:climasys/climasys/features/account_view/widgets/edit_account_details_dialog.dart';
import 'package:climasys/climasys/features/account_view/widgets/profile_picture_widget.dart';
import 'package:climasys/climasys/features/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  // We'll load and store account details here.
  late Future<GetAccountDetailsQueryResponse> futureAccountDetails;

  @override
  void initState() {
    super.initState();
    futureAccountDetails = getAccountDetails();
  }

  /// Refresh the account details from the server.
  Future<void> _refreshAccountDetails() async {
    setState(() {
      futureAccountDetails = getAccountDetails();
    });
  }

  /// Called when the user taps the "Delete Account" button.
  void handleDelete() async {
    try {
      final credentials = await confirmAccountDeletion(context);

      // If the user cancelled (tapped 'Cancel'), credentials will be null
      if (credentials == null) {
        return;
      }

      final username = credentials['username'];
      final password = credentials['password'];

      // Now you have the user's input for username and password
      await deleteAccount(username!, password!);

      // Example: Clear secure storage, then navigate to login screen
      await secureStorage.deleteAll();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete account')),
      );
    }
  }

  void showEditAccountDetailsDialog(String friendlyName, String bioText ) async {
      await showDialog<EditAccountDetailsDialog>(
        context: context,
        builder: (context) =>
            EditAccountDetailsDialog(
            currentDisplayName: friendlyName,
            currentBio: bioText,
            onEditComplete: () async {
              await _refreshAccountDetails();
            },
            context: context,
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
      ),
      body: FutureBuilder<GetAccountDetailsQueryResponse>(
        future: futureAccountDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading indicator while we fetch account details
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error
            return Center(
              child: Text('Failed to load account details: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            // No data returned
            return const Center(child: Text('No account details found.'));
          }

          // We have valid data here
          final accountDetails = snapshot.data!;
          final profilePicUrl = accountDetails.profilePictureUrl ??
              'https://via.placeholder.com/180'; // fallback image

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 1) Display the profile picture at about 1/3 of screen width
                ProfilePictureWidget(
                  initialImageUrl: profilePicUrl,
                  onImageUploaded: () async {
                    // After a successful upload, refresh account details
                    await _refreshAccountDetails();
                  },
                ),
                const SizedBox(height: 24),

                // 2) Display other user details in a nice layout
                Card(
                  elevation: 2.0,
                  child: Stack(
                    children: [
                      // Main content
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Display Name: ${accountDetails.friendlyName ?? "N/A"}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Username: ${accountDetails.userName}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Email: ${accountDetails.email ?? "N/A"}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bio: ${accountDetails.bioText ?? "N/A"}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Joined: ${accountDetails.dateCreated ?? "N/A"}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),

                      // Edit icon in top-right corner
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit Profile',
                          onPressed: () {
                            showEditAccountDetailsDialog(
                              accountDetails.friendlyName ?? '',
                              accountDetails.bioText ?? ''
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 3) Delete account button
                ElevatedButton(
                  onPressed: handleDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("Delete Account"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}