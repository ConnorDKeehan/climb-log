import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/api/models/facility.dart';
import 'package:climasys/climasys/api/models/gym_about_details.dart';
import 'package:climasys/climasys/api/models/opening_hour.dart';
import 'package:climasys/climasys/features/gym_about/widgets/address_row/address_row.dart';
import 'package:climasys/climasys/features/gym_about/widgets/facilities_expansion_tile/facilities_expansion_tile.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:flutter/material.dart';
import 'widgets/opening_hours_expansion_tile/opening_hours_expansion_tile.dart';

class GymAbout extends StatefulWidget {
  const GymAbout({super.key});

  @override
  State<GymAbout> createState() => _GymAboutState();
}

class _GymAboutState extends State<GymAbout> {
  GymAboutDetails? _gymAboutDetails;
  bool _isLoading = true;
  bool isGymAdmin = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeGymAboutPage();
  }

  void _refreshGym() {
    _initializeGymAboutPage();
  }

  Future<void> _initializeGymAboutPage() async {
    try {
      final gymName = await getGymName(context);
      final details = await getGymAboutDetails(gymName);

      isGymAdmin = await isUserGymAdmin(gymName: gymName);

      setState(() {
        _gymAboutDetails = details;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load details: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Gym Details")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _gymAboutDetails == null
                  ? const Center(child: Text('No details available.'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AddressRow(
                            address: _gymAboutDetails?.address,
                            isGymAdmin: isGymAdmin,
                            refreshGym: _refreshGym,
                          ),
                          const Divider(),
                          // Section: Opening Hours
                          OpeningHoursExpansionTile(
                            openingHours: _gymAboutDetails?.openingHours ??
                                <OpeningHour>[],
                            currentlyOpen: _gymAboutDetails?.currentlyOpen,
                            todayStartTime: _gymAboutDetails?.todayStartTime,
                            todayEndTime: _gymAboutDetails?.todayEndTime,
                            theme: theme,
                            isGymAdmin: isGymAdmin,
                            refreshGym: _refreshGym,
                          ),

                          // Section: Facilities
                          FacilitiesExpansionTile(
                              facilities:
                                  _gymAboutDetails?.facilities ?? <Facility>[],
                              theme: theme,
                              isGymAdmin: isGymAdmin,
                              refreshGym: _refreshGym),
                        ],
                      ),
                    ),
    );
  }
}
