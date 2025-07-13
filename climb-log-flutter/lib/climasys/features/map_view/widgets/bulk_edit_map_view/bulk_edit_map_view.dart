import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/api/models/gym.dart';
import 'package:climasys/climasys/api/models/route.dart' as RouteModel;
import 'package:climasys/climasys/features/map_view/widgets/bulk_edit_map_view/bulk_alter_competition_button.dart';
import 'package:climasys/climasys/features/map_view/widgets/map_and_routes/map_and_routes.dart';
import 'package:climasys/utils/confirm_action_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';

class BulkEditMapView extends StatefulWidget {
  final Gym gym;
  final List<RouteModel.Route> routes;
  final File mapSvg;

  const BulkEditMapView({
    super.key,
    required this.gym,
    required this.routes,
    required this.mapSvg,
  });

  @override
  State<BulkEditMapView> createState() => _BulkEditMapViewState();
}

class _BulkEditMapViewState extends State<BulkEditMapView> {
  Set<int> selectedRouteIds = {};
  Offset? dragStart;
  Offset? dragCurrent;

  final GlobalKey _imageKey = GlobalKey();
  final TransformationController transformationController =
  TransformationController();

  // Update selection rectangle
  void _updateSelection(double containerWidth, double containerHeight) {
    if (dragStart == null || dragCurrent == null) return;

    final Rect selectionRect = Rect.fromPoints(dragStart!, dragCurrent!);
    final newSelectedRouteIds = <int>{};

    for (var route in widget.routes) {
      // Convert normalized coords to actual container coords
      final routePosition = Offset(
        route.xCord * containerWidth,
        route.yCord * containerHeight,
      );
      if (selectionRect.contains(routePosition)) {
        newSelectedRouteIds.add(route.id);
        route.isSelected = true;
      } else {
        route.isSelected = false;
      }
    }

    setState(() {
      selectedRouteIds = newSelectedRouteIds;
    });
  }

  // Toggle a single route in Bulk Edit mode
  void _toggleRouteSelection(int routeId) {
    final route = widget.routes.firstWhere((r) => r.id == routeId);
    setState(() {
      if (selectedRouteIds.contains(routeId)) {
        selectedRouteIds.remove(routeId);
        route.isSelected = false;
      } else {
        selectedRouteIds.add(routeId);
        route.isSelected = true;
      }
    });
  }

  Future<void> _confirmBulkArchive() async {
    final bool? confirm = await confirmActionDialog(context);
    if (confirm == true) {
      try {
        await bulkArchiveRoutes(selectedRouteIds.toList(), widget.gym.name);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Routes archived successfully')),
        );
        Navigator.of(context).pop(true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error archiving routes: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk Edit Mode'),
        actions: [
          if(selectedRouteIds.isNotEmpty)
            BulkAlterCompetitionButton(routeIds: selectedRouteIds.toList()),
          if (selectedRouteIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.archive),
              onPressed: _confirmBulkArchive,
            ),
        ],
      ),
      body: Stack(
        children: [
          // 1) Keep your AspectRatio so the map is rendered at the proper size.
          AspectRatio(
            aspectRatio: widget.gym.viewBoxXSize.toDouble() /
                widget.gym.viewBoxYSize.toDouble(),
            child: LayoutBuilder(
              builder: (ctx, constraints) {
                final containerWidth = constraints.maxWidth;
                final containerHeight = constraints.maxHeight;

                return Stack(
                  children: [
                    // 2) Keep the InteractiveViewer if you want pinch/zoom/pan
                    InteractiveViewer(
                      transformationController: transformationController,
                      // Optional boundaryMargin if you want to allow panning
                      // a bit beyond edges:
                      // boundaryMargin: const EdgeInsets.all(30),
                      clipBehavior: Clip.none,
                      minScale: 1.0,
                      maxScale: 5.0,

                      // 3) GestureDetector on top so we can draw the selection rect
                      child: GestureDetector(
                        onPanStart: (details) {
                          setState(() {
                            dragStart = details.localPosition;
                            dragCurrent = dragStart;
                          });
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            dragCurrent = details.localPosition;
                            _updateSelection(containerWidth, containerHeight);
                          });
                        },
                        onPanEnd: (details) {
                          setState(() {
                            dragStart = null;
                            dragCurrent = null;
                          });
                        },

                        // 4) Show your map + pins
                        child: MapAndRoutes(
                          isGymAdmin: true,
                          isUserLoggedIn: true,
                          routes: widget.routes,
                          mapSvg: widget.mapSvg,
                          containerWidth: containerWidth,
                          containerHeight: containerHeight,
                          transformationController: transformationController,
                          bulkEditMode: true,
                          enableSectors: false,
                          basePinSize: 3,
                          imageKey: _imageKey,
                          // Provide the callback for toggling
                          onToggleSelection: _toggleRouteSelection,
                        ),
                      ),
                    ),

                    // 5) Draw the selection rectangle on top
                    if (dragStart != null && dragCurrent != null)
                      Positioned.fromRect(
                        rect: Rect.fromPoints(dragStart!, dragCurrent!),
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 2),
                              color: Colors.blue.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
