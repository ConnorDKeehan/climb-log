import 'package:climasys/climasys/features/account_view/account_view_api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureWidget extends StatefulWidget {
  final String initialImageUrl;
  final VoidCallback onImageUploaded;

  /// Provide an initial profile image URL (e.g. from your backend).
  const ProfilePictureWidget({
    super.key,
    required this.initialImageUrl,
    required this.onImageUploaded
  });

  @override
  State<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  late String _imageUrl;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.initialImageUrl;
  }

  /// This is the function you provided, with slight modifications
  /// so it can refresh the image if needed.
  Future<void> updateProfilePictureFromPicker() async {
    final picker = ImagePicker();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        // The actual upload request:
        // (Replace with your own function that does the POST.)
        await postUpdatedProfilePicture(pickedFile);

        widget.onImageUploaded();

        // For now, just show a success message:
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Profile picture uploaded successfully!')),
        );
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Sorry! Picture failed to upload. Please try again or report the issue.',
            ),
          ),
        );
      }
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('You must pick a picture to upload')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageSize = screenWidth / 3;

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Large circular profile pic
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                // Replace with whatever image provider you use (file, network, memory, etc.)
                image: NetworkImage(_imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Pencil (edit) icon in bottom‐right corner
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: updateProfilePictureFromPicker,
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.black54, // or your color of choice
                child: Icon(
                  Icons.edit,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}