import 'package:climasys/climasys/features/gym_about/widgets/address_row/edit_address_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AddressRow extends StatefulWidget {
  final String? address;
  final bool isGymAdmin;
  final VoidCallback refreshGym;

  const AddressRow(
      {super.key,
      required this.address,
      required this.isGymAdmin,
      required this.refreshGym});

  @override
  State<StatefulWidget> createState() => _AddressRowState();
}

class _AddressRowState extends State<AddressRow> {
  Future<void> openMaps(String? address) async {
    if (address == null) {
      return;
    }

    final encodedAddress = Uri.encodeComponent(address);

    try {
      // Try Apple Maps on iOS
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final appleMapsUrl = "http://maps.apple.com/?q=$encodedAddress";
        if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
          await launchUrl(Uri.parse(appleMapsUrl),
              mode: LaunchMode.externalApplication);
          return;
        }
      }

      // Try geo: (Android)
      final geoUrl = "geo:0,0?q=$encodedAddress";
      if (await canLaunchUrl(Uri.parse(geoUrl))) {
        await launchUrl(Uri.parse(geoUrl),
            mode: LaunchMode.externalApplication);
        return;
      }
    } finally {
      // Fallback: Google Maps universal link
      final googleMapsUrl =
          "https://www.google.com/maps/search/?api=1&query=$encodedAddress";
      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(Uri.parse(googleMapsUrl),
            mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not open the map.';
      }
    }
  }

  Future<void> openEditAddressAlert() async {
    await showDialog<EditAddressAlert>(
        context: context,
        builder: (context) => EditAddressAlert(
              address: widget.address ?? '',
              refreshGym: widget.refreshGym,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openMaps(widget.address);
      },
      child: Row(
        children: [
          const Icon(Icons.location_pin, color: Colors.deepPurple),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.address != null ? widget.address! : 'N/A',
              style: Theme.of(context).textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.isGymAdmin)
            IconButton(
                icon: const Icon(Icons.edit_location),
                onPressed: openEditAddressAlert)
        ],
      ),
    );
  }
}
