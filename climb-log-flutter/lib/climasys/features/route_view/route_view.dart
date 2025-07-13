import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/features/route_view/models/get_route_info_query_response.dart';
import 'package:climasys/climasys/features/route_view/widgets/archive_button.dart';
import 'package:climasys/climasys/features/route_view/widgets/beta_videos_view.dart';
import 'package:climasys/climasys/features/route_view/widgets/edit_climb_button.dart';
import 'package:climasys/climasys/features/route_view/widgets/log_climb_button.dart';
import 'package:climasys/climasys/features/route_view/widgets/route_details/route_details.dart';
import 'package:climasys/climasys/features/route_view/widgets/unlog_climb_button.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:flutter/material.dart';

class RouteView extends StatefulWidget {
  final int routeId;
  final bool hasAscended;
  final VoidCallback onActionCompleted;
  final bool isUserAdmin;

  const RouteView({
    super.key,
    required this.routeId,
    required this.hasAscended,
    required this.onActionCompleted,
    required this.isUserAdmin,
  });

  @override
  State<RouteView> createState() => _RouteViewState();
}

class _RouteViewState extends State<RouteView> {
  bool isLoading = true;
  bool isGymAdmin = false;
  late GetRouteInfoQueryResponse getRouteInfoQueryResponse;
  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {
    final gymName = await getGymName(context);
    isGymAdmin = await isUserGymAdmin(gymName: gymName);
    getRouteInfoQueryResponse = await getRouteInfo(widget.routeId);

    setState(() {
      isLoading = false;
    });
  }

  void navigateToBetaVideos() {
    // Navigate to the RouteView page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BetaVideosView(
              routeId: widget.routeId
            ),
      ),
    );
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route View'),
        actions: [
          if(isGymAdmin) EditClimbButton(routeId: widget.routeId),
          IconButton(onPressed: navigateToBetaVideos, icon: const Icon(Icons.photo_camera)),
        ],
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator()) : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row for buttons or the "Sent" badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (widget.isUserAdmin)
                  ArchiveButton(routeId: widget.routeId, onActionCompleted: widget.onActionCompleted),
                if (!widget.hasAscended)
                  LogClimbButton(routeId: widget.routeId, onActionCompleted: widget.onActionCompleted)
                else
                  UnlogClimbButton(routeId: widget.routeId, onActionCompleted: widget.onActionCompleted),
              ],
            ),
            Expanded(child: RouteDetails(routeInfo: getRouteInfoQueryResponse))
          ],
        ),
      ),
    );
  }
}
